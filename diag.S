    lui x1, 0xf0c2c
		lui x5, 0x08000

		li  x4, 0x48
		sb  x4, 0(x5)
		lb  x4, 0(x5)
		lb  x6, 0(x5)
		//addi x4, x4, 1
		sb	x6, 0(x1)
    # Print Hello world
    li  x3, 0x48
    sb  x3, 0(x1)
    li  x3, 0x66
    sb  x3, 0(x1)
    li  x3, 0x6c
    sb  x3, 0(x1)
    li  x3, 0x6c
    sb  x3, 0(x1)
    li  x3, 0x6F
    sb  x3, 0(x1)
    li  x3, 0x20
    sb  x3, 0(x1)
    li  x3, 0x77
    sb  x3, 0(x1)
    li  x3, 0x6f
    sb  x3, 0(x1)
    li  x3, 0x72
    sb  x3, 0(x1)
    li  x3, 0x6c
    sb  x3, 0(x1)
    li  x3, 0x64
    sb  x3, 0(x1)
#    lw  x4, 0(x1)
#		addi x4, x4, 0
#    sb  x4, 0(x1)
#		lw  x4, 0(x1)
#    addi x4, x4, 1
#    sb  x4, 0(x1)
#		lw  x4, 0(x1)
#    addi x4, x4, 1
#    sb  x4, 0(x1)
#		lw  x4, 0(x1)
#    addi x4, x4, 1
#    sb  x4, 0(x1)

# sit in loop and increment counter, because why not
    addi x2, x0, 0
loop:     
    addi    x2,x2,1
    j       loop
