from virtual_memory_toolkit.handles.handle cimport CAppHandle, CAppHandle_from_title_substring, CAppHandle_free
from virtual_memory_toolkit.memory.memory_structures cimport CVirtualAddress, CVirtualAddress_from_aob, CVirtualAddress_init,CVirtualAddress_write_int32, CVirtualAddress_read_int32, CVirtualAddress_free
from virtual_memory_toolkit.memory.memory_structures cimport CModule, CModule_from_process, CModule_free
from virtual_memory_toolkit.process.process cimport CProcess, CProcess_init, CProcess_free

cimport seed_hook

cdef int menu(CAppHandle* noita_handle, CVirtualAddress* seed_address, CVirtualAddress* seed_overwrite_address):

    cdef unsigned int new_seed
    cdef unsigned int read_seed

    choice = 0

    while choice != 3:
        
        print("Enter menu number:")
        print(" 1) Set seed.")
        print(" 2) View current seed.")
        print(" 3) Exit.")

        choice = input(": ")

        try:
            choice = int(choice) 
        except TypeError:
            print("Please enter a number...")
            choice = -1
        
        if choice == 1:
            new_seed = get_new_seed()
            if CVirtualAddress_write_int32(seed_overwrite_address, <const unsigned int>new_seed):
                print("Unsuccessfully set new seed " + str(new_seed))
            else:
                print("Successfully set new seed " + str(new_seed))
            input("Press ENTER to continue...")
            
        elif choice == 2:
            if CVirtualAddress_read_int32(seed_overwrite_address, <int *>&read_seed):
                print("Cannot read overwritten seed!")
            else:
                if not read_seed:
                    if CVirtualAddress_read_int32(seed_address, <int*>&read_seed):
                        print("Cannot read seed!")
            
            print("Current seed is " + str(read_seed))
            input("Press ENTER to continue...")

        elif choice == 3:
            CVirtualAddress_write_int32(seed_overwrite_address, <const int>0)

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
    cdef CVirtualAddress* seed_overwrite_address = seed_hook.get_seed_overwrite_address(noita_handle, noita_exe_module, seed_address)

    menu(noita_handle, seed_address, seed_overwrite_address)

    CModule_free(noita_exe_module)
    CProcess_free(noita_process)
    CAppHandle_free(noita_handle)

    return 0
    