class c_4_1;
    int UART_BASE_ADDRESS = 536870912;
    rand bit[2:0] req_adr_i; // rand_mode = ON 

    constraint WITH_CONSTRAINT_this    // (constraint_mode = ON) (../wishbone/sv/wishbone_sequences.sv:487)
    {
       (req_adr_i == (UART_BASE_ADDRESS + (4 * 3)));
    }
endclass

program p_4_1;
    c_4_1 obj;
    string randState;

    initial
        begin
            obj = new;
            randState = "x11x0z11111101011z1xx0zzx0x1xzzzzzxxxzxxxzzxxzxzzxzzxxxxxxzxxzxz";
            obj.set_randstate(randState);
            obj.randomize();
        end
endprogram
