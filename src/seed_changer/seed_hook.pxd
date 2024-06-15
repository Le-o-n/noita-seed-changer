from virtual_memory_toolkit.handles.handle cimport CAppHandle, CAppHandle_from_title_substring, CAppHandle_free
from virtual_memory_toolkit.memory.memory_structures cimport CVirtualAddress, CVirtualAddress_from_aob, CVirtualAddress_free
from virtual_memory_toolkit.memory.memory_structures cimport CModule, CModule_from_process, CModule_free
from virtual_memory_toolkit.process.process cimport CProcess, CProcess_init, CProcess_free


cdef inline CAppHandle* get_noita_handle():
    cdef char* window_title_substring = "Noita"
    return CAppHandle_from_title_substring(<const char*> window_title_substring)
    
cdef inline void* get_seed_address(CAppHandle* noita_handle):

    if not noita_handle:
        return NULL

    cdef char* noita_exe_string = "noita.exe"
    cdef CProcess* noita_process = CProcess_init(noita_handle)

    if not noita_process:
        return NULL

    cdef CModule* noita_exe_module = CModule_from_process(noita_process, <const char*>noita_exe_string)

    if not noita_exe_module:
        CProcess_free(noita_process)
        return NULL

    cdef unsigned long long start_address = <unsigned long long>noita_exe_module[0].base_address
    cdef unsigned long long end_address = <unsigned long long>start_address + <unsigned long long>noita_exe_module[0].size

    cdef unsigned char[9] c_bytes

    py_bytes = [0x0F, 0x28, 0xF8, 0xF3, 0x0F, 0x11, 0x45, 0xFC, 0x83]

    for i, b in enumerate(py_bytes):
        c_bytes[i] = <unsigned char> b
    
    cdef CVirtualAddress* seed_opcode_address = CVirtualAddress_from_aob(
        noita_handle, 
        <const void*>start_address, 
        <const void*>end_address, 
        <unsigned char*>&c_bytes, 
        9
    )
    
    if not seed_opcode_address:
        CProcess_free(noita_process)
        return NULL

    print("found opcode address at " + hex(<unsigned long long>seed_opcode_address[0].address))    
    

    cdef void* address = seed_opcode_address[0].address

    CVirtualAddress_free(seed_opcode_address)
    CProcess_free(noita_process)

    return address
    

cdef inline int main():

    cdef CAppHandle* noita_handle = get_noita_handle()
    cdef void* seed_address = get_seed_address(noita_handle)

    return 0