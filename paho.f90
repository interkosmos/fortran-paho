! paho.f90
!
! Eclipse Paho MQTT client interface for Fortran 2008.
!
! Author:   Philipp Engel
! Licence:  ISC
! Source:   https://github.com/interkosmos/f08paho/
module paho
    use, intrinsic :: iso_c_binding
    implicit none

    ! MQTTProperties
    type, bind(c) :: mqtt_properties
        integer(kind=c_int) :: count
        integer(kind=c_int) :: max_count
        integer(kind=c_int) :: length
        type(c_ptr)         :: array
    end type mqtt_properties

    ! MQTTClient_message
    type, bind(c) :: mqtt_client_message
        character(kind=c_char, len=1) :: struct_id(4)
        integer(kind=c_int)           :: struct_version
        integer(kind=c_int)           :: payload_len
        type(c_ptr)                   :: payload
        integer(kind=c_int)           :: qos
        integer(kind=c_int)           :: retained
        integer(kind=c_int)           :: dup
        integer(kind=c_int)           :: msg_id
        type(mqtt_properties)         :: properties
    end type mqtt_client_message

    ! MQTTClient_init_options
    type, bind(c) :: mqtt_client_init_options
        character(kind=c_char, len=1) :: struct_id(4)
        integer(kind=c_int)           :: struct_version
        integer(kind=c_int)           :: do_openssl_init
    end type mqtt_client_init_options

    type, bind(c) :: returned_type
        type(c_ptr) :: server_uri
        integer(kind=c_int) :: mqtt_version
        integer(kind=c_int) :: session_present
    end type returned_type

    type, bind(c) :: binary_pwd_type
        integer(kind=c_int) :: len
        type(c_ptr)         :: data
    end type binary_pwd_type

    ! MQTTClient_connectOptions
    type, bind(c) :: mqtt_client_connect_options
        character(kind=c_char, len=1) :: struct_id(4)
        integer(kind=c_int)           :: struct_version
        integer(kind=c_int)           :: keep_alive_interval
        integer(kind=c_int)           :: clean_session
        integer(kind=c_int)           :: reliable
        type(c_ptr)                   :: will
        type(c_ptr)                   :: user_name
        type(c_ptr)                   :: password
        integer(kind=c_int)           :: connect_timeout
        integer(kind=c_int)           :: retry_interval
        type(c_ptr)                   :: ssl
        integer(kind=c_int)           :: server_uri_count
        type(c_ptr)                   :: server_uris
        integer(kind=c_int)           :: mqtt_version
        type(returned_type)           :: returned
        type(binary_pwd_type)         :: binary_pwd
        integer(kind=c_int)           :: max_inflight_messages
        integer(kind=c_int)           :: clean_start
    end type mqtt_client_connect_options

    integer(kind=c_int), parameter :: MQTTCLIENT_PERSISTENCE_NONE      = 1
    integer(kind=c_int), parameter :: MQTTCLIENT_SUCCESS               = 0
    integer(kind=c_int), parameter :: MQTTCLIENT_FAILURE               = -1
    integer(kind=c_int), parameter :: MQTTCLIENT_DISCONNECTED          = -3
    integer(kind=c_int), parameter :: MQTTCLIENT_MAX_MESSAGES_INFLIGHT = -4
    integer(kind=c_int), parameter :: MQTTCLIENT_BAD_UTF8_STRING       = -5
    integer(kind=c_int), parameter :: MQTTCLIENT_NULL_PARAMETER        = -6
    integer(kind=c_int), parameter :: MQTTCLIENT_TOPICNAME_TRUNCATED   = -7
    integer(kind=c_int), parameter :: MQTTCLIENT_BAD_STRUCTURE         = -8
    integer(kind=c_int), parameter :: MQTTCLIENT_BAD_QOS               = -9
    integer(kind=c_int), parameter :: MQTTCLIENT_SSL_NOT_SUPPORTED     = -10
    integer(kind=c_int), parameter :: MQTTCLIENT_BAD_MQTT_VERSION      = -11
    integer(kind=c_int), parameter :: MQTTCLIENT_BAD_PROTOCOL          = -14
    integer(kind=c_int), parameter :: MQTTCLIENT_BAD_MQTT_OPTION       = -15
    integer(kind=c_int), parameter :: MQTTCLIENT_WRONG_MQTT_VERSION    = -16
    integer(kind=c_int), parameter :: MQTTVERSION_DEFAULT              = 0
    integer(kind=c_int), parameter :: MQTTVERSION_3_1                  = 3
    integer(kind=c_int), parameter :: MQTTVERSION_3_1_1                = 4
    integer(kind=c_int), parameter :: MQTTVERSION_5                    = 5
    integer(kind=c_int), parameter :: MQTT_BAD_SUBSCRIBE               = int(z'80')
    integer(kind=c_int), parameter :: MQTT_SSL_VERSION_DEFAULT         = 0
    integer(kind=c_int), parameter :: MQTT_SSL_VERSION_TLS_1_0         = 1
    integer(kind=c_int), parameter :: MQTT_SSL_VERSION_TLS_1_1         = 2
    integer(kind=c_int), parameter :: MQTT_SSL_VERSION_TLS_1_2         = 3

    ! MQTTClient_init_options_initializer
    type(mqtt_client_init_options), parameter :: MQTT_CLIENT_INIT_OPTIONS_INITIALIZER = &
        mqtt_client_init_options(['M', 'Q', 'T', 'C'], 0, 0)

    ! MQTTClient_connectOptions_initializer
    type(mqtt_client_connect_options), parameter :: MQTT_CLIENT_CONNECT_OPTIONS_INITIALIZER = &
        mqtt_client_connect_options(['M', 'Q', 'T', 'C'], 5, 60, 1, 1, c_null_ptr, c_null_ptr, c_null_ptr, 30, 20, c_null_ptr, &
                                    0, c_null_ptr, 0, returned_type(c_null_ptr, 0, 0), binary_pwd_type(0, c_null_ptr), -1, 0)

    ! MQTTProperties_initializer
    type(mqtt_properties), parameter :: MQTT_PROPERTIES_INITIALIZER = mqtt_properties(0, 0, 0, c_null_ptr)

    ! MQTTClient_message_initializer
    type(mqtt_client_message), parameter :: MQTT_CLIENT_MESSAGE_INITIALIZER  = &
        mqtt_client_message([ 'M', 'Q', 'T', 'M' ], 1, 0, c_null_ptr, 0, 0, 0, 0, MQTT_PROPERTIES_INITIALIZER)

    public :: c_f_string_chars
    public :: mqtt_client_connect
    public :: mqtt_client_create
    public :: mqtt_client_destroy
    public :: mqtt_client_disconnect
    public :: mqtt_client_free
    public :: mqtt_client_free_message
    public :: mqtt_client_payload
    public :: mqtt_client_publish_message
    public :: mqtt_client_set_callbacks
    public :: mqtt_client_subscribe
    public :: mqtt_client_topic_name
    public :: mqtt_client_wait_for_completion

    interface
        ! int MQTTClient_connect(MQTTClient handle, MQTTClient_connectOptions *options)
        function mqtt_client_connect(handle, options) bind(c, name='MQTTClient_connect')
            import :: c_int, c_ptr, mqtt_client_connect_options
            implicit none
            type(c_ptr),                       intent(in), value :: handle
            type(mqtt_client_connect_options), intent(in)        :: options
            integer(kind=c_int)                                  :: mqtt_client_connect
        end function mqtt_client_connect

        ! int MQTTClient_create(MQTTClient *handle, const char *serverURI, const char *clientId, int persistence_type, void *persistence_context)
        function mqtt_client_create(handle, server_uri, client_id, persistence_type, persistence_context) &
                bind(c, name='MQTTClient_create')
            import :: c_char, c_int, c_ptr
            implicit none
            type(c_ptr),            intent(in)        :: handle
            character(kind=c_char), intent(in)        :: server_uri
            character(kind=c_char), intent(in)        :: client_id
            integer(kind=c_int),    intent(in), value :: persistence_type
            type(c_ptr),            intent(in), value :: persistence_context
            integer(kind=c_int)                       :: mqtt_client_create
        end function mqtt_client_create

        ! int MQTTClient_disconnect(MQTTClient handle, int timeout)
        function mqtt_client_disconnect(handle, timeout) bind(c, name='MQTTClient_disconnect')
            import :: c_int, c_ptr
            implicit none
            type(c_ptr),         intent(in), value :: handle
            integer(kind=c_int), intent(in), value :: timeout
            integer(kind=c_int)                    :: mqtt_client_disconnect
        end function mqtt_client_disconnect

        ! int MQTTClient_publishMessage(MQTTClient handle, const char* topicName, MQTTClient_message* msg, MQTTClient_deliveryToken* dt);
        function mqtt_client_publish_message(handle, topic_name, msg, dt) bind(c, name='MQTTClient_publishMessage')
            import :: c_char, c_int, c_ptr, mqtt_client_message
            implicit none
            type(c_ptr),               intent(in), value :: handle
            character(kind=c_char),    intent(in)        :: topic_name
            type(mqtt_client_message), intent(in)        :: msg
            integer(kind=c_int),       intent(in out)    :: dt
            integer(kind=c_int)                          :: mqtt_client_publish_message
        end function mqtt_client_publish_message

        ! int MQTTClient_setCallbacks(MQTTClient handle, void *context, MQTTClient_connectionLost *cl, MQTTClient_messageArrived *ma, MQTTClient_deliveryComplete *dc);
        function mqtt_client_set_callbacks(handle, context, cl, ma, dc) bind(c, name='MQTTClient_setCallbacks')
            import :: c_funptr, c_int, c_ptr
            implicit none
            type(c_ptr),    intent(in), value :: handle
            type(c_ptr),    intent(in), value :: context
            type(c_funptr), intent(in), value :: cl
            type(c_funptr), intent(in), value :: ma
            type(c_funptr), intent(in), value :: dc
            integer(kind=c_int)               :: mqtt_client_set_callbacks
        end function mqtt_client_set_callbacks

        ! int MQTTClient_subscribe(MQTTClient handle, const char *topic, int qos)
        function mqtt_client_subscribe(handle, topic, qos) bind(c, name='MQTTClient_subscribe')
            import :: c_char, c_int, c_ptr
            implicit none
            type(c_ptr),            intent(in), value :: handle
            character(kind=c_char), intent(in)        :: topic
            integer(kind=c_int),    intent(in), value :: qos
            integer(kind=c_int)                       :: mqtt_client_subscribe
        end function mqtt_client_subscribe

        ! int MQTTClient_waitForCompletion(MQTTClient handle, MQTTClient_deliveryToken dt, unsigned long timeout);
        function mqtt_client_wait_for_completion(handle, dt, timeout) bind(c, name='MQTTClient_waitForCompletion')
            import :: c_int, c_long, c_ptr
            implicit none
            type(c_ptr),          intent(in), value :: handle
            integer(kind=c_int),  intent(in), value :: dt
            integer(kind=c_long), intent(in), value :: timeout
            integer(kind=c_int)                     :: mqtt_client_wait_for_completion
        end function mqtt_client_wait_for_completion

        ! void MQTTClient_destroy(MQTTClient *handle)
        subroutine mqtt_client_destroy(handle) bind(c, name='MQTTClient_destroy')
            import :: c_ptr
            implicit none
            type(c_ptr), intent(in) :: handle
        end subroutine mqtt_client_destroy

        ! void MQTTClient_free(void *ptr)
        subroutine mqtt_client_free(ptr) bind(c, name='MQTTClient_free')
            import :: c_ptr
            implicit none
            type(c_ptr), intent(in), value :: ptr
        end subroutine mqtt_client_free

        ! void MQTTClient_freeMessage(MQTTClient_message **msg)
        subroutine mqtt_client_free_message(msg) bind(c, name='MQTTClient_freeMessage')
            import :: c_ptr
            implicit none
            type(c_ptr), intent(in) :: msg
        end subroutine mqtt_client_free_message
    end interface
contains
    subroutine c_f_string_chars(c_string, f_string)
        !! Copies a C string, passed as a char-array reference,
        !! to a Fortran string.
        use, intrinsic :: iso_c_binding, only: C_NULL_CHAR, c_char
        implicit none
        character(len=1, kind=c_char), intent(in)  :: c_string(:)
        character(len=*),              intent(out) :: f_string
        integer                                    :: i

        i = 1

        do while (c_string(i) /= C_NULL_CHAR .and. i <= len(f_string))
            f_string(i:i) = c_string(i)
            i = i + 1
        end do

        if (i < len(f_string)) &
            f_string(i:) = ' '
    end subroutine c_f_string_chars

    function mqtt_client_payload(ptr)
        use, intrinsic :: iso_c_binding, only: c_char, c_ptr
        type(c_ptr),               intent(in)  :: ptr
        character(len=:),          allocatable :: mqtt_client_payload
        type(mqtt_client_message), pointer     :: message_ptr
        character(kind=c_char),    pointer     :: payload_ptrs(:)

        if (.not. c_associated(ptr)) &
            return

        call c_f_pointer(ptr, message_ptr)
        call c_f_pointer(message_ptr%payload, payload_ptrs, shape=[message_ptr%payload_len])
        allocate (character(message_ptr%payload_len) :: mqtt_client_payload)
        call c_f_string_chars(payload_ptrs, mqtt_client_payload)
    end function mqtt_client_payload

    function mqtt_client_topic_name(ptr, length)
        use, intrinsic :: iso_c_binding, only: c_char, c_ptr
        type(c_ptr),            intent(in)  :: ptr
        integer,                intent(in)  :: length
        character(kind=c_char), pointer     :: topic_name_ptrs(:)
        character(len=:),       allocatable :: mqtt_client_topic_name

        if (.not. c_associated(ptr)) &
            return

        allocate (character(length) :: mqtt_client_topic_name)
        call c_f_pointer(ptr, topic_name_ptrs, shape=[length])
        call c_f_string_chars(topic_name_ptrs, mqtt_client_topic_name)
        mqtt_client_topic_name = trim(mqtt_client_topic_name)
    end function mqtt_client_topic_name
end module paho
