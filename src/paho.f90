! paho.f90
!
! Eclipse Paho MQTT client interface for Fortran 2008.
!
! Author:   Philipp Engel
! Licence:  ISC
module paho
    use, intrinsic :: iso_c_binding
    use :: paho_util
    implicit none
    private

    integer, parameter, public :: c_unsigned_long = c_long

    integer(kind=c_int), parameter, public :: MQTTCLIENT_PERSISTENCE_NONE = 1

    integer(kind=c_int), parameter, public :: MQTTCLIENT_SUCCESS               = 0
    integer(kind=c_int), parameter, public :: MQTTCLIENT_FAILURE               = -1
    integer(kind=c_int), parameter, public :: MQTTCLIENT_DISCONNECTED          = -3
    integer(kind=c_int), parameter, public :: MQTTCLIENT_MAX_MESSAGES_INFLIGHT = -4
    integer(kind=c_int), parameter, public :: MQTTCLIENT_BAD_UTF8_STRING       = -5
    integer(kind=c_int), parameter, public :: MQTTCLIENT_NULL_PARAMETER        = -6
    integer(kind=c_int), parameter, public :: MQTTCLIENT_TOPICNAME_TRUNCATED   = -7
    integer(kind=c_int), parameter, public :: MQTTCLIENT_BAD_STRUCTURE         = -8
    integer(kind=c_int), parameter, public :: MQTTCLIENT_BAD_QOS               = -9
    integer(kind=c_int), parameter, public :: MQTTCLIENT_SSL_NOT_SUPPORTED     = -10
    integer(kind=c_int), parameter, public :: MQTTCLIENT_BAD_MQTT_VERSION      = -11
    integer(kind=c_int), parameter, public :: MQTTCLIENT_BAD_PROTOCOL          = -14
    integer(kind=c_int), parameter, public :: MQTTCLIENT_BAD_MQTT_OPTION       = -15
    integer(kind=c_int), parameter, public :: MQTTCLIENT_WRONG_MQTT_VERSION    = -16
    integer(kind=c_int), parameter, public :: MQTTCLIENT_0_LEN_WILL_TOPIC      = -17

    integer(kind=c_int), parameter, public :: MQTTVERSION_DEFAULT = 0
    integer(kind=c_int), parameter, public :: MQTTVERSION_3_1     = 3
    integer(kind=c_int), parameter, public :: MQTTVERSION_3_1_1   = 4
    integer(kind=c_int), parameter, public :: MQTTVERSION_5       = 5

    integer(kind=c_int), parameter, public :: MQTT_BAD_SUBSCRIBE = int(z'80')

    integer(kind=c_int), parameter, public :: MQTT_SSL_VERSION_DEFAULT = 0
    integer(kind=c_int), parameter, public :: MQTT_SSL_VERSION_TLS_1_0 = 1
    integer(kind=c_int), parameter, public :: MQTT_SSL_VERSION_TLS_1_1 = 2
    integer(kind=c_int), parameter, public :: MQTT_SSL_VERSION_TLS_1_2 = 3

    ! MQTTProperties
    type, bind(c), public :: mqtt_properties
        integer(kind=c_int) :: count     = 0
        integer(kind=c_int) :: max_count = 0
        integer(kind=c_int) :: length    = 0
        type(c_ptr)         :: array     = c_null_ptr
    end type mqtt_properties

    ! MQTTClient_message
    type, bind(c), public :: mqtt_client_message
        character(kind=c_char) :: struct_id(4)   = [ 'M', 'Q', 'T', 'M' ]
        integer(kind=c_int)    :: struct_version = 1
        integer(kind=c_int)    :: payload_len    = 0
        type(c_ptr)            :: payload        = c_null_ptr
        integer(kind=c_int)    :: qos            = 0
        integer(kind=c_int)    :: retained       = 0
        integer(kind=c_int)    :: dup            = 0
        integer(kind=c_int)    :: msg_id         = 0
        type(mqtt_properties)  :: properties
    end type mqtt_client_message

    ! MQTTClient_init_options
    type, bind(c), public :: mqtt_client_init_options
        character(kind=c_char) :: struct_id(4)    = ['M', 'Q', 'T', 'G']
        integer(kind=c_int)    :: struct_version  = 0
        integer(kind=c_int)    :: do_openssl_init = 0
    end type mqtt_client_init_options

    ! MQTTClient_nameValue
    type, bind(c), public :: mqtt_client_name_value_type
        type(c_ptr) :: name  = c_null_ptr ! const char *
        type(c_ptr) :: value = c_null_ptr ! const char *
    end type mqtt_client_name_value_type

    ! MQTTClient_connectOptions
    type, bind(c), public :: mqtt_returned_type
        type(c_ptr)         :: server_uri      = c_null_ptr ! const char *
        integer(kind=c_int) :: mqtt_version    = 0
        integer(kind=c_int) :: session_present = 0
    end type mqtt_returned_type

    type, bind(c), public :: mqtt_binary_pwd_type
        integer(kind=c_int) :: len  = 0
        type(c_ptr)         :: data = c_null_ptr ! const void *
    end type mqtt_binary_pwd_type

    type, bind(c), public :: mqtt_client_connect_options
        character(kind=c_char)     :: struct_id(4)          = ['M', 'Q', 'T', 'C']
        integer(kind=c_int)        :: struct_version        = 8
        integer(kind=c_int)        :: keep_alive_interval   = 60
        integer(kind=c_int)        :: clean_session         = 1
        integer(kind=c_int)        :: reliable              = 1
        type(c_ptr)                :: will                  = c_null_ptr ! MQTTClient_willOptions *
        type(c_ptr)                :: user_name             = c_null_ptr ! const char *
        type(c_ptr)                :: password              = c_null_ptr ! const char *
        integer(kind=c_int)        :: connect_timeout       = 30
        integer(kind=c_int)        :: retry_interval        = 0
        type(c_ptr)                :: ssl                   = c_null_ptr ! MQTTClient_SSLOptions *
        integer(kind=c_int)        :: server_uri_count      = 0
        type(c_ptr)                :: server_uris           = c_null_ptr ! char * const *
        integer(kind=c_int)        :: mqtt_version          = MQTTVERSION_DEFAULT
        type(mqtt_returned_type)   :: returned
        type(mqtt_binary_pwd_type) :: binary_pwd
        integer(kind=c_int)        :: max_inflight_messages = -1
        integer(kind=c_int)        :: clean_start           = 0
        type(c_ptr)                :: http_headers          = c_null_ptr ! const MQTTClient_nameValue *
        type(c_ptr)                :: http_proxy            = c_null_ptr ! const char *
        type(c_ptr)                :: https_proxy           = c_null_ptr ! const char *
    end type mqtt_client_connect_options

    ! MQTTClient_init_options_initializer
    type(mqtt_client_init_options), parameter, public :: MQTT_CLIENT_INIT_OPTIONS_INITIALIZER = &
        mqtt_client_init_options(['M', 'Q', 'T', 'C'], 0, 0)

    ! MQTTClient_connectOptions_initializer
    type(mqtt_client_connect_options), parameter, public  :: MQTT_CLIENT_CONNECT_OPTIONS_INITIALIZER = &
        mqtt_client_connect_options(['M', 'Q', 'T', 'C'], 8, 60, 1, 1, c_null_ptr, c_null_ptr, c_null_ptr, 30, 20, c_null_ptr, &
                                    0, c_null_ptr, MQTTVERSION_DEFAULT, mqtt_returned_type(c_null_ptr, 0, 0), &
                                    mqtt_binary_pwd_type(0, c_null_ptr), -1, 0, c_null_ptr, c_null_ptr, c_null_ptr)

    ! MQTTClient_connectOptions_initializer5
    type(mqtt_client_connect_options), parameter, public  :: MQTTCLIENT_CONNECT_OPTIONS_INITIALIZER_5 = &
        mqtt_client_connect_options(['M', 'Q', 'T', 'C'], 8, 60, 1, 1, c_null_ptr, c_null_ptr, c_null_ptr, 30, 20, c_null_ptr, &
                                    0, c_null_ptr, MQTTVERSION_5, mqtt_returned_type(c_null_ptr, 0, 0), &
                                    mqtt_binary_pwd_type(0, c_null_ptr), -1, 0, c_null_ptr, c_null_ptr, c_null_ptr)

    ! MQTTProperties_initializer
    type(mqtt_properties), parameter, public :: MQTT_PROPERTIES_INITIALIZER = mqtt_properties(0, 0, 0, c_null_ptr)

    ! MQTTClient_message_initializer
    type(mqtt_client_message), parameter, public :: MQTT_CLIENT_MESSAGE_INITIALIZER  = &
        mqtt_client_message([ 'M', 'Q', 'T', 'M' ], 1, 0, c_null_ptr, 0, 0, 0, 0, MQTT_PROPERTIES_INITIALIZER)

    public :: mqtt_client_connect
    public :: mqtt_client_create
    public :: mqtt_client_destroy
    public :: mqtt_client_disconnect
    public :: mqtt_client_free
    public :: mqtt_client_free_message
    public :: mqtt_client_publish_message
    public :: mqtt_client_set_callbacks
    public :: mqtt_client_subscribe
    public :: mqtt_client_wait_for_completion

    public :: mqtt_client_payload

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
            integer(kind=c_int),       intent(out)       :: dt
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
            import :: c_int, c_ptr, c_unsigned_long
            implicit none
            type(c_ptr),                   intent(in), value :: handle
            integer(kind=c_int),           intent(in), value :: dt
            integer(kind=c_unsigned_long), intent(in), value :: timeout
            integer(kind=c_int)                              :: mqtt_client_wait_for_completion
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
    function mqtt_client_payload(ptr) result(str)
        type(c_ptr),      intent(in)  :: ptr
        character(len=:), allocatable :: str

        type(mqtt_client_message), pointer :: message_ptr

        if (c_associated(ptr)) then
            call c_f_pointer(ptr, message_ptr)
            call c_f_str_ptr(message_ptr%payload, str, size=message_ptr%payload_len)
            return
        end if

        if (.not. allocated(str)) str = ''
    end function mqtt_client_payload
end module paho
