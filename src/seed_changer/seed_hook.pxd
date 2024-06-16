from virtual_memory_toolkit.handles.handle cimport CAppHandle, CAppHandle_from_title_substring, CAppHandle_free
from virtual_memory_toolkit.memory.memory_structures cimport CVirtualAddress, CVirtualAddress_from_aob, CVirtualAddress_init,CVirtualAddress_write_int32, CVirtualAddress_write_int8_offset,CVirtualAddress_write_int32_offset, CVirtualAddress_offset, CVirtualAddress_read_int32_offset, CVirtualAddress_free
from virtual_memory_toolkit.memory.memory_structures cimport CModule, CModule_from_process, CModule_free
from virtual_memory_toolkit.process.process cimport CProcess, CProcess_init, CProcess_free


cdef inline CAppHandle* get_noita_handle():
    cdef char* window_title_substring = "Noita"
    return CAppHandle_from_title_substring(<const char*> window_title_substring)


cdef inline CVirtualAddress* get_seed_address(CAppHandle* noita_handle, CModule* noita_module):

    if not noita_handle:
        return NULL

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
    

    cdef int seed_address

    if CVirtualAddress_read_int32_offset(seed_opcode_address, &seed_address, <long long> 1):
        CVirtualAddress_free(seed_opcode_address)
        return NULL
    
    CVirtualAddress_free(seed_opcode_address)

    return CVirtualAddress_init(noita_handle, <void*> seed_address)
    

cdef inline CVirtualAddress* get_seed_overwrite_address(CAppHandle* noita_handle, CModule* noita_module, CVirtualAddress* seed_address):
    
    if not noita_handle:
        return NULL

    cdef unsigned long long start_address = <unsigned long long>0x006E0000 #noita_exe_module[0].base_address
    cdef unsigned long long end_address = <unsigned long long>start_address + <unsigned long long>noita_module[0].size

    cdef unsigned int seed_addr = <unsigned int>seed_address[0].address

    cdef unsigned char byte0 = (seed_addr >> 0) & 0xFF
    cdef unsigned char byte1 = (seed_addr >> 8) & 0xFF
    cdef unsigned char byte2 = (seed_addr >> 16) & 0xFF
    cdef unsigned char byte3 = (seed_addr >> 24) & 0xFF

    
    cdef unsigned char[5] c_bytes

    py_bytes = [0xc7, 0x05, byte0, byte1, byte2, byte3]


    for i, b in enumerate(py_bytes):
        c_bytes[i] = <unsigned char> b
    
    cdef CVirtualAddress* overwrite_seed_opcode = CVirtualAddress_from_aob(
        noita_handle, 
        <const void*>start_address, 
        <const void*>end_address, 
        <unsigned char*>&c_bytes, 
        <size_t>len(py_bytes)
    )

    CVirtualAddress_offset(overwrite_seed_opcode, 6)
    return overwrite_seed_opcode

