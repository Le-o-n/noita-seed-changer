from virtual_memory_toolkit.handles.handle cimport CAppHandle, CAppHandle_from_title_substring, CAppHandle_free
from libc.stdlib cimport free

cpdef int main():
    cdef char* window_title_substring = "Noita"
    cdef CAppHandle* app_handle = CAppHandle_from_title_substring(<const char*> window_title_substring)
    
    if app_handle:
        print("success in getting handle to noita")
    else:
        print("cannot get handle to noita")


    free(window_title_substring)
    CAppHandle_free(app_handle)
    return 0
