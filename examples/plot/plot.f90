! plot.f90
!
! Example connects to an MQTT message broker, subscribes a topic, parses
! payload in JSON format, and prints values with DISLIN.
!
! Author:   Philipp Engel
! Licence:  ISC
! Source:   https://github.com/interkosmos/f08paho/
program main
    use, intrinsic :: iso_c_binding, only: C_NULL_CHAR, c_null_ptr, c_ptr
    use :: dislin
    use :: json_module
    use :: paho
    implicit none

    integer,          parameter :: dp         = selected_real_kind(15, 307)
    character(len=*), parameter :: PLOT_TITLE = 'Fortran + MQTT + JSON + DISLIN'
    character(len=*), parameter :: ADDRESS    = 'tcp://localhost:1883'
    character(len=*), parameter :: CLIENT_ID  = 'FortranClient'
    character(len=*), parameter :: TOPIC      = 'fortran'
    integer,          parameter :: QOS        = 1
    integer,          parameter :: N          = 1000

    character(len=1)                  :: input
    type(json_file)                   :: json
    type(c_ptr)                       :: client
    type(mqtt_client_connect_options) :: conn_opts = MQTT_CLIENT_CONNECT_OPTIONS_INITIALIZER
    real                              :: x_ray(N), y_ray(N)
    integer                           :: delivered_token
    integer                           :: rc
    integer                           :: length = 1

    ! Initialise DISLIN and JSON.
    call init_dislin()
    call json%initialize()

    ! Create MQTT client.
    rc = mqtt_client_create(client, &
                            ADDRESS // C_NULL_CHAR, &
                            CLIENT_ID // C_NULL_CHAR, &
                            MQTTCLIENT_PERSISTENCE_NONE, &
                            c_null_ptr)
    ! Set connection options.
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
    rc = mqtt_client_subscribe(client, TOPIC // C_NULL_CHAR, QOS)
    print '(5a, i0, a)', 'Subscribing to topic "', TOPIC, '" for client "', &
                         CLIENT_ID, '" using QoS ', QOS, ' ...'

    ! Wait for user input.
    do while (.true.)
        read *, input
    end do

    ! Clean-up.
    rc = mqtt_client_disconnect(client, 10000)
    call mqtt_client_destroy(client)
    call json%destroy()
    call disfin()
contains
    subroutine init_dislin()
        implicit none
        integer :: c

        call metafl('CONS')
        call scrmod('REVERS')
        call winsiz(800, 600)

        call disini()

        ! Set font.
        ! call bmpfnt('SIMPLEX')
        call simplx()
        ! call complx()
        ! call x11fnt('-Adobe-Helvetica-Medium-R-Normal-', 'STANDARD')

        call wintit(PLOT_TITLE)
        call paghdr('f08paho demo /', '/ Fortran 2008', 1, 0)

        call name('X-Axis', 'x')
        call name('Y-Axis', 'y')

        call labdig(-1, 'x')
        call ticks(10, 'xy')

        call titlin(PLOT_TITLE, 1)

        c = intrgb(0.95, 0.95, 0.95)
        call axsbgd(c)

        call graf(0., 100., 0., 10., -2., 2., -2.0, 1.)
        call setrgb(0.7, 0.7, 0.7)
        call grid(1, 1)

        call color('FORE')
        call title()

        call color('RED')
    end subroutine init_dislin

    ! void MQTTClient_deliveryComplete(void *context, MQTTClient_deliveryToken dt)
    subroutine delivery_complete(context, dt) bind(c)
        use, intrinsic :: iso_c_binding
        implicit none
        type(c_ptr),         intent(in), value :: context
        integer(kind=c_int), intent(in)        :: dt

        print '(a, i0, a)', 'Message with token value ', dt, ' delivery confirmed'
        delivered_token = dt
    end subroutine delivery_complete

    ! int MQTTClient_messageArrived(void *context, char *topicName, int topicLen, MQTTClient_message *message)
    function message_arrived(context, topic_name, topic_len, message) bind(c)
        use, intrinsic :: iso_c_binding
        use :: paho
        implicit none
        type(c_ptr),         intent(in), value :: context
        type(c_ptr),         intent(in), value :: topic_name
        integer(kind=c_int), intent(in), value :: topic_len
        type(c_ptr),         intent(in), value :: message
        integer(kind=c_int)                    :: message_arrived
        character(len=:),    allocatable       :: tn
        character(len=:),    allocatable       :: pl
        logical                                :: found
        real(kind=dp)                          :: x, y

        ! Get topic name and payload data.
        tn = mqtt_client_topic_name(topic_name, len(TOPIC))
        pl = mqtt_client_payload(message)

        print '(a)', 'Message arrived ...'

        ! Parse JSON.
        call json%load_from_string(pl); if (json%failed()) stop
        call json%get('x', x, found); if (.not. found) stop
        call json%get('y', y, found); if (.not. found) stop

        print '(a, f6.3)', 'x: ', x
        print '(a, f6.3)', 'y: ', y

        ! Store values in arrays.
        x_ray(length:length) = real(x, kind=4)
        y_ray(length:length) = real(y, kind=4)

        ! Plot curve.
        call curve(x_ray, y_ray, length)
        call sendbf()
        length = length + 1

        ! Clean-up.
        call mqtt_client_free_message(message)
        call mqtt_client_free(topic_name)
        message_arrived = 1
    end function message_arrived

    ! void MQTTClient_connectionLost(void *context, char *cause)
    subroutine connection_lost(context, cause) bind(c)
        use, intrinsic :: iso_c_binding
        use :: paho
        implicit none
        type(c_ptr),            intent(in), value :: context
        type(c_ptr),            intent(in), value :: cause
        character(kind=c_char), pointer           :: cause_ptrs(:)
        character(len=100)                        :: cause_str

        ! Get cause as Fortran string.
        call c_f_pointer(cause, cause_ptrs, shape=[len(cause_str)])
        call c_f_string_chars(cause_ptrs, cause_str)

        print '(a)',  'Connection lost'
        print '(2a)', '    cause: ', trim(cause_str)
    end subroutine connection_lost
end program main
