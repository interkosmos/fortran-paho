! subscribe.f90
!
! Example that shows how to connect to an MQTT message broker, subscribe to a
! topic, and print received messages.
!
! Author:   Philipp Engel
! Licence:  ISC
! Source:   https://github.com/interkosmos/f08paho/
program main
    use, intrinsic :: iso_c_binding, only: C_NULL_CHAR, c_char, c_null_ptr, c_ptr
    use :: paho
    implicit none

    character(len=*), parameter :: ADDRESS   = 'tcp://localhost:1883'
    character(len=*), parameter :: CLIENT_ID = 'FortranSubClient'
    character(len=*), parameter :: TOPIC     = 'fortran'
    integer,          parameter :: QOS       = 1

    type(c_ptr)                       :: client
    type(mqtt_client_connect_options) :: conn_opts = MQTT_CLIENT_CONNECT_OPTIONS_INITIALIZER
    integer                           :: token
    integer                           :: rc
    character(len=1)                  :: input

    ! Create MQTT client.
    rc = mqtt_client_create(client, &
                            ADDRESS // C_NULL_CHAR, &
                            CLIENT_ID // C_NULL_CHAR, &
                            MQTTCLIENT_PERSISTENCE_NONE, &
                            c_null_ptr)

    conn_opts%keep_alive_interval = 20
    conn_opts%clean_session       = 1

    ! Set callback procedures.
    rc = mqtt_client_set_callbacks(client, &
                                   c_null_ptr, &
                                   c_funloc(connection_lost), &
                                   c_funloc(message_arrived), &
                                   c_funloc(delivery_complete))
    ! Connect to MQTT message broker.
    rc = mqtt_client_connect(client, conn_opts)

    if (rc /= MQTTCLIENT_SUCCESS) then
        print '(a, i0)', 'Failed to connect, return code ', rc
        stop
    end if

    ! Subscribe to topic.
    print '(5a, i0, a)', 'Subscribing to topic "', TOPIC, '" for client "', &
                         CLIENT_ID, '" using QoS ', QOS, ' ...'
    rc = mqtt_client_subscribe(client, TOPIC // C_NULL_CHAR, QOS)
    print '(a)', 'Press Q<Enter> to quit'

    ! Wait for keyboard input.
    do while (.true.)
        read *, input

        if (input == 'Q' .or. input == 'q') &
            exit
    end do

    rc = mqtt_client_disconnect(client, 10000)
    call mqtt_client_destroy(client)
contains
    ! void MQTTClient_deliveryComplete(void *context, MQTTClient_deliveryToken dt)
    subroutine delivery_complete(context, dt) bind(c)
        implicit none
        type(c_ptr),         intent(in), value :: context
        integer(kind=c_int), intent(in)        :: dt

        print '(a, i0, a)', 'Message with token value ', dt, ' delivery confirmed'
        token = dt
    end subroutine delivery_complete

    ! int MQTTClient_messageArrived(void *context, char *topicName, int topicLen, MQTTClient_message *message)
    function message_arrived(context, topic_name, topic_len, message) bind(c)
        implicit none
        type(c_ptr),         intent(in), value :: context
        type(c_ptr),         intent(in), value :: topic_name
        integer(kind=c_int), intent(in), value :: topic_len
        type(c_ptr),         intent(in), value :: message
        integer(kind=c_int)                    :: message_arrived

        print '(a)',  'Message arrived ...'
        print '(2a)', '  Topic: ', mqtt_client_topic_name(topic_name, len(TOPIC))
        print '(2a)', 'Payload: ', mqtt_client_payload(message)

        call mqtt_client_free_message(message)
        call mqtt_client_free(topic_name)
        message_arrived = 1
    end function message_arrived

    ! void MQTTClient_connectionLost(void *context, char *cause)
    subroutine connection_lost(context, cause) bind(c)
        implicit none
        type(c_ptr),            intent(in), value :: context
        type(c_ptr),            intent(in), value :: cause
        character(kind=c_char), pointer           :: cause_ptrs(:)
        character(len=100)                        :: cause_str

        ! Get cause as Fortran string.
        call c_f_pointer(cause, cause_ptrs, shape=[len(cause_str)])
        call c_f_string_chars(cause_ptrs, cause_str)

        print '(a)',  'Connection lost'
        print '(2a)', '    cause: ', cause_str
    end subroutine connection_lost
end program main
