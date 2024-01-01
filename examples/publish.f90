! publish.f90
!
! Example that shows how to connect to an MQTT message broker and publish to a
! topic.
!
! Author:   Philipp Engel
! Licence:  ISC
program main
    use, intrinsic :: iso_c_binding
    use :: paho
    implicit none

    character(len=*), parameter :: ADDRESS   = 'tcp://localhost:1883'
    character(len=*), parameter :: CLIENT_ID = 'FortranPubClient'
    character(len=*), parameter :: TOPIC     = 'fortran'
    integer,          parameter :: QOS       = 1
    integer,          parameter :: TIMEOUT   = 10000

    integer :: rc
    integer :: token

    character(len=:), allocatable, target :: payload
    type(c_ptr)                           :: client
    type(mqtt_client_connect_options)     :: conn_opts
    type(mqtt_client_message)             :: pub_msg

    payload = 'Hello, World!'

    mqtt_block: block
        ! Create MQTT client.
        rc = mqtt_client_create(client, &
                                ADDRESS // c_null_char, &
                                CLIENT_ID // c_null_char, &
                                MQTTCLIENT_PERSISTENCE_NONE, &
                                c_null_ptr)

        conn_opts%keep_alive_interval = 20
        conn_opts%clean_session       = 1

        ! Connect to MQTT message broker.
        rc = mqtt_client_connect(client, conn_opts)

        if (rc /= MQTTCLIENT_SUCCESS) then
            print '("Failed to connect: ", i0)', rc
            exit mqtt_block
        end if

        pub_msg%payload     = c_loc(payload)
        pub_msg%payload_len = len(payload)
        pub_msg%qos         = QOS
        pub_msg%retained    = 0

        rc = mqtt_client_publish_message(client, TOPIC // c_null_char, pub_msg, token)

        print '(a, i0, 7a)', 'Waiting for up to ', TIMEOUT / 1000, ' second(s) for publication of "', &
                             trim(payload), '" on topic "', TOPIC, '" for client with client id "', &
                             CLIENT_ID, '"'

        rc = mqtt_client_wait_for_completion(client, token, int(TIMEOUT, kind=c_unsigned_long))

        print '("Message with token ", i0, " delivered")', token

        rc = mqtt_client_disconnect(client, TIMEOUT)
    end block mqtt_block

    call mqtt_client_destroy(client)
end program main
