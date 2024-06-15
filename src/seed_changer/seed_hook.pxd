from virtual_memory_toolkit.handles.handle cimport CAppHandle, CAppHandle_from_title_substring, CAppHandle_free
from virtual_memory_toolkit.memory.memory_structures cimport CVirtualAddress, CVirtualAddress_from_aob, CVirtualAddress_init, CVirtualAddress_write_int8_offset,CVirtualAddress_write_int32_offset, CVirtualAddress_offset, CVirtualAddress_read_int32_offset, CVirtualAddress_free
from virtual_memory_toolkit.memory.memory_structures cimport CModule, CModule_from_process, CModule_free
from virtual_memory_toolkit.process.process cimport CProcess, CProcess_init, CProcess_free


cdef inline CAppHandle* get_noita_handle():
    cdef char* window_title_substring = "Noita"
    return CAppHandle_from_title_substring(<const char*> window_title_substring)


cdef inline CVirtualAddress* find_seed_set_opcode(CAppHandle* noita_handle, CModule* noita_module):
    cdef unsigned long long start_address = <unsigned long long>0x008833E0 #noita_exe_module[0].base_address
    cdef unsigned long long end_address = <unsigned long long>start_address + <unsigned long long>noita_module[0].size

    cdef unsigned char[5] c_bytes

    py_bytes = [
        0x5e,               # pop esi
        0x0f, 0x44, 0xc1,   # cmove eax, ecx
        0xa3                # mov [X], eax      <<
    ]

    for i, b in enumerate(py_bytes):
        c_bytes[i] = <unsigned char> b
    
    cdef CVirtualAddress* seed_opcode_address = CVirtualAddress_from_aob(
        noita_handle, 
        <const void*>start_address, 
        <const void*>end_address, 
        <unsigned char*>&c_bytes, 
        <size_t>len(py_bytes)
    )
    CVirtualAddress_offset(seed_opcode_address, <long long>4)
    return seed_opcode_address


cdef inline CVirtualAddress* get_seed_address(CAppHandle* noita_handle, CVirtualAddress* seed_set_opcode):

    if not noita_handle:
        return NULL

    cdef int seed_address

    if CVirtualAddress_read_int32_offset(seed_set_opcode, &seed_address, <long long> 1):
        CVirtualAddress_free(seed_set_opcode)
        print("Cannot read at offset")
        return NULL

    
    CVirtualAddress_free(seed_set_opcode)

    return CVirtualAddress_init(noita_handle, <void*> seed_address)
    


cdef inline bint enable_stop_seed_overwrite(CAppHandle* noita_handle, CVirtualAddress* seed_set_opcode):

    if not noita_handle:
        return 1

    py_bytes = [
        0x90,       # nop
        0x90,       # nop
        0x90,       # nop
        0x90,       # nop
        0x90        # nop
    ]
    cdef bint valid = False
    for i, b in enumerate(py_bytes):
        valid = valid or CVirtualAddress_write_int8_offset(seed_set_opcode, <const unsigned char>b, <long long>i)
    
    return not valid

cdef inline bint disable_stop_seed_overwrite(CAppHandle* noita_handle, CVirtualAddress* seed_set_opcode, CVirtualAddress* seed_address):

    if not noita_handle:
        return 1

    py_bytes = [
        0xa3,       # mov [X], eax
    ]

    print("seed address being written is " + hex(<unsigned long long>seed_address[0].address))

    cdef bint valid = 1

    valid = CVirtualAddress_write_int8_offset(seed_set_opcode, <const unsigned char>py_bytes[0], <long long>0) and valid
    valid = CVirtualAddress_write_int32_offset(seed_set_opcode, <const int><unsigned long long>seed_address[0].address, <long long>1) and valid
    
    return not valid 




cdef inline int main():
    cdef char* noita_exe_string = "noita.exe"
    cdef CAppHandle* noita_handle = get_noita_handle()
    cdef CProcess* noita_process = CProcess_init(noita_handle)
    cdef CModule* noita_exe_module = CModule_from_process(noita_process, <const char*>noita_exe_string)

    cdef CVirtualAddress* seed_set_opcode = find_seed_set_opcode(noita_handle, noita_exe_module)
    cdef CVirtualAddress* seed_address = get_seed_address(noita_handle, seed_set_opcode)

    enable_stop_seed_overwrite(noita_handle, seed_set_opcode)
    input()
    disable_stop_seed_overwrite(noita_handle, seed_set_opcode, seed_address)

    return 0