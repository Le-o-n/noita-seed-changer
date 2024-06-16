from virtual_memory_toolkit.handles.handle cimport CAppHandle, CAppHandle_from_title_substring, CAppHandle_free
from virtual_memory_toolkit.memory.memory_structures cimport CVirtualAddress, CVirtualAddress_from_aob, CVirtualAddress_init,CVirtualAddress_write_int32, CVirtualAddress_read_int32, CVirtualAddress_free
from virtual_memory_toolkit.memory.memory_structures cimport CModule, CModule_from_process, CModule_free
from virtual_memory_toolkit.process.process cimport CProcess, CProcess_init, CProcess_free

cimport seed_hook

cdef int menu(CAppHandle* noita_handle, CVirtualAddress* seed_address, CVirtualAddress* seed_overwrite_address):
    cdef unsigned int new_seed
    cdef unsigned int read_seed

    cdef unsigned int line_width = 43
    
    choice = 0
    while choice != 3:
        print("\n" + "="*line_width)
        print("╔╗╔┌─┐┬┌┬┐┌─┐  ╔═╗┌─┐┌─┐┌┬┐  ╔╦╗┌─┐┌─┐┬  ")
        print("║║║│ ││ │ ├─┤  ╚═╗├┤ ├┤  ││   ║ │ ││ ││  ")
        print("╝╚╝└─┘┴ ┴ ┴ ┴  ╚═╝└─┘└─┘─┴┘   ╩ └─┘└─┘┴─┘")
        print("="*line_width)
        print(" 1) Set seed.")
        print(" 2) View current seed.")
        print(" 3) Exit.")
        print("="*line_width)

        choice = input("Enter menu number: ")

        try:
            choice = int(choice)
        except ValueError:
            print("Please enter a valid number...")
            choice = -1
        
        print("="*line_width)
        if choice == 1:
            new_seed = get_new_seed(line_width)
            if CVirtualAddress_write_int32(seed_overwrite_address, <const unsigned int>new_seed):
                print(f"Unsuccessfully set new seed {new_seed}")
            else:
                if new_seed == 0:
                    print("Random generation of seeds restored")
                else:
                    print(f"Successfully set new seed {new_seed}")
            print("="*line_width)
            input("Press ENTER to continue...")
            
        elif choice == 2:

            if CVirtualAddress_read_int32(seed_address, <int*>&read_seed):
                print("Cannot read seed!")
            else:
                print(f"Current seed is {read_seed}")

            print("="*line_width)
            input("Press ENTER to continue...")

        elif choice == 3:
            CVirtualAddress_write_int32(seed_overwrite_address, <const int>0)
            print("\nExiting...")




cdef unsigned int get_new_seed(unsigned int line_width):
    num = -1

    while num < 0:
        try:
            num = int(input("Enter new seed (0 to restore and exit).\n: "))
            print("="*line_width)
            if num > 4_294_967_295:
                num = 4_294_967_295
        except TypeError:
            print("="*line_width)
            print("Please input a number!")
            print("="*line_width)
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
    