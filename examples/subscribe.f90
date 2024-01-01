! subscribe.f90
!
! Example that shows how to connect to an MQTT message broker, subscribe to a
! topic, and print received messages.
!
! Author:   Philipp Engel
! Licence:  ISC
program main
    use, intrinsic :: iso_c_binding
    use :: paho
    use :: paho_util
    implicit none

    character(len=*), parameter :: ADDRESS   = 'tcp://localhost:1883'
    character(len=*), parameter :: CLIENT_ID = 'FortranSubClient'
    character(len=*), parameter :: TOPIC     = 'fortran'
    integer,          parameter :: QOS       = 1

    character   :: input
    integer     :: rc
    type(c_ptr) :: client

    type(mqtt_client_connect_options) :: conn_opts

    mqtt_block: block
        ! Create MQTT client.
        rc = mqtt_client_create(client, &
                                ADDRESS // c_null_char, &
                                CLIENT_ID // c_null_char, &
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
            print '("Failed to connect: ", i0)', rc
            exit mqtt_block
        end if

        ! Subscribe to topic.
        print '(5a, i0, a)', 'Subscribing to topic "', TOPIC, '" for client "', &
                             CLIENT_ID, '" using QoS ', QOS, ' ...'

        rc = mqtt_client_subscribe(client, TOPIC // c_null_char, QOS)

        ! Wait for keyboard input.
        print '("Press <q> + <Enter> to quit")'

        do
            read *, input
            if (input == 'Q' .or. input == 'q') exit
        end do

        rc = mqtt_client_disconnect(client, 10000)
    end block mqtt_block

    call mqtt_client_destroy(client)
contains
    ! void MQTTClient_deliveryComplete(void *context, MQTTClient_deliveryToken dt)
    subroutine delivery_complete(context, dt) bind(c)
        type(c_ptr),         intent(in), value :: context
        integer(kind=c_int), intent(in), value :: dt

        print '("Delivery of message with token ", i0, " confirmed")', dt
    end subroutine delivery_complete

    ! int MQTTClient_messageArrived(void *context, char *topicName, int topicLen, MQTTClient_message *message)
    function message_arrived(context, topic_name, topic_len, message) bind(c)
        use :: paho_util, only: c_f_str_ptr
        type(c_ptr),         intent(in), value :: context
        type(c_ptr),         intent(in), value :: topic_name
        integer(kind=c_int), intent(in), value :: topic_len
        type(c_ptr),         intent(in), value :: message
        integer(kind=c_int)                    :: message_arrived

        character(len=:), allocatable :: topic

        call c_f_str_ptr(topic_name, topic)

        print '("Message arrived ...")'
        print '("  Topic: ", a)', topic
        print '("Payload: ", a)', mqtt_client_payload(message)

        call mqtt_client_free_message(message)
        call mqtt_client_free(topic_name)

        message_arrived = 1
    end function message_arrived

    ! void MQTTClient_connectionLost(void *context, char *cause)
    subroutine connection_lost(context, cause) bind(c)
        type(c_ptr), intent(in), value :: context
        type(c_ptr), intent(in), value :: cause

        character(len=:), allocatable :: str

        call c_f_str_ptr(cause, str)
        print '("Connection lost: ", a)', str
    end subroutine connection_lost
end program main
