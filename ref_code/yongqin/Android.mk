LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)
LOCAL_SRC_FILES := \
        main_strcpy.c \
        string_copy_linaro_wrapper.S \
        string_copy_google_wrapper.S \

LOCAL_STATIC_LIBRARIES := libc 

LOCAL_MODULE := strcpy_linaro_static 
LOCAL_MODULE_TAGS := optional tests

LOCAL_MULTILIB := 64
LOCAL_CFLAGS += -std=gnu99

LOCAL_FORCE_STATIC_EXECUTABLE := true

include $(BUILD_EXECUTABLE)

include $(CLEAR_VARS)
LOCAL_SRC_FILES := \
        main_strcpy.c \
        string_copy_linaro_wrapper.S \
        string_copy_google_wrapper.S \

LOCAL_MODULE := strcpy_linaro_dynamic 
LOCAL_MODULE_TAGS := optional tests

LOCAL_MULTILIB := 64
LOCAL_CFLAGS += -std=gnu99

include $(BUILD_EXECUTABLE)
