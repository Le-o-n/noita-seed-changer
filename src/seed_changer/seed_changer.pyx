from virtual_memory_toolkit.handles.handle cimport CAppHandle, CAppHandle_from_title_substring, CAppHandle_free
from virtual_memory_toolkit.memory.memory_structures cimport CVirtualAddress, CVirtualAddress_from_aob, CVirtualAddress_init,CVirtualAddress_write_int32, CVirtualAddress_write_int8_offset,CVirtualAddress_write_int32_offset, CVirtualAddress_offset, CVirtualAddress_read_int32_offset, CVirtualAddress_free
from virtual_memory_toolkit.memory.memory_structures cimport CModule, CModule_from_process, CModule_free
from virtual_memory_toolkit.process.process cimport CProcess, CProcess_init, CProcess_free

cimport seed_hook


cdef unsigned int get_new_seed():
    num = -1

    while num < 0:
        try:
            num = int(input("Enter new seed (0 to restore and exit).\n: "))
            if num > 4_294_967_295:
                num = 4_294_967_295
        except TypeError:
            print("Please input a number")
            num = -1
    return <unsigned int>num


cpdef int main():
    cdef char* noita_exe_string = "noita.exe"
    cdef CAppHandle* noita_handle = seed_hook.get_noita_handle()
    cdef CProcess* noita_process = CProcess_init(noita_handle)
    cdef CModule* noita_exe_module = CModule_from_process(noita_process, <const char*>noita_exe_string)


    cdef CVirtualAddress* seed_address = seed_hook.get_seed_address(noita_handle, noita_exe_module)

    cdef CVirtualAddress* seed_overwrite_address = seed_hook.get_overwrite_address(noita_handle, noita_exe_module, seed_address)

    cdef unsigned int new_seed = 1

    while new_seed:
        new_seed = get_new_seed()
        if CVirtualAddress_write_int32(seed_overwrite_address, <const unsigned int>new_seed):
            print(" Unsuccessfully tried to write new seed...")
        else:
            print(" Successfully injected new seed...")

    CModule_free(noita_exe_module)
    CProcess_free(noita_process)
    CAppHandle_free(noita_handle)

    return 0
    