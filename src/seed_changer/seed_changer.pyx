"""
    Noita Seed Changer - A tool for changing the seed of the video game
    "Noita" using runtime modifications the game's virtual memory.
    Copyright (C) 2024  Leon Bass (https://github.com/Le-o-n)

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
"""

from virtual_memory_toolkit.handles.handle cimport CAppHandle, CAppHandle_from_title_substring, CAppHandle_free
from virtual_memory_toolkit.memory.memory_structures cimport CVirtualAddress, CVirtualAddress_from_aob, CVirtualAddress_init,CVirtualAddress_write_int32, CVirtualAddress_read_int32, CVirtualAddress_free
from virtual_memory_toolkit.memory.memory_structures cimport CModule, CModule_from_process, CModule_free
from virtual_memory_toolkit.process.process cimport CProcess, CProcess_init, CProcess_free
import os
cimport seed_hook

cdef int menu(CAppHandle* noita_handle, CVirtualAddress* seed_address, CVirtualAddress* seed_overwrite_address):
    cdef unsigned int new_seed
    cdef unsigned int read_seed

    cdef unsigned int line_width = 43
    
    choice = 0
    while choice != 3:
        os.system('cls')
        print("\n" + "="*line_width)
        print(" ╔╗╔┌─┐┬┌┬┐┌─┐  ╔═╗┌─┐┌─┐┌┬┐  ╔╦╗┌─┐┌─┐┬   ")
        print(" ║║║│ ││ │ ├─┤  ╚═╗├┤ ├┤  ││   ║ │ ││ ││   ")
        print(" ╝╚╝└─┘┴ ┴ ┴ ┴  ╚═╝└─┘└─┘─┴┘   ╩ └─┘└─┘┴─┘ ")
        print(" by Leon Bass (https://github.com/Le-o-n)")
        print("="*line_width)
        print(" 1) set seed")
        print(" 2) view current seed")
        print(" 3) exit")
        print("="*line_width)

        choice = input("Enter menu number: ")

        try:
            choice = int(choice)
        except ValueError:
            print("Please enter a valid number...")
            input("Press ENTER to continue...")
            choice = -1

        os.system('cls')

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
            print("Exiting...")
            



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
    if not noita_handle:
        print("Cannot get handle to Noita process...")
        print("Ensure that Noita is running and that you run as Administrator")
        input("Press ENTER to exit...")
        return 1
    else:
        print("Successfully abtained handle to Noita...")

    cdef CProcess* noita_process = CProcess_init(noita_handle)
    if not noita_process:
        print("Could not enumerate Noita modules...")
        return 1
    else:
        print("Successfully enumerated all Noita modules...")

    cdef CModule* noita_exe_module = CModule_from_process(noita_process, <const char*>noita_exe_string)
    if not noita_exe_module:
        print("Cannot get access to noita.exe module information...")
        return 1
    else:
        print("Successfully accessed noita.exe module information...")


    cdef CVirtualAddress* seed_address = seed_hook.get_seed_address(noita_handle, noita_exe_module)
    if not seed_address:
        print("Cannot get access to seed address...")
        print("Try downloading the latest version.")
        return 1
    else:
        print("Successfully retrieved the seed address...")
    
    cdef CVirtualAddress* seed_overwrite_address = seed_hook.get_seed_overwrite_address(noita_handle, noita_exe_module, seed_address)
    if not seed_address:
        print("Cannot get access to seed address...")
        print("Try downloading the latest version.")
        return 1
    else:
        print("Successfully retrieved the address to overwrite the seed...")

    menu(noita_handle, seed_address, seed_overwrite_address)

    CModule_free(noita_exe_module)
    CProcess_free(noita_process)
    CAppHandle_free(noita_handle)

    return 0
    