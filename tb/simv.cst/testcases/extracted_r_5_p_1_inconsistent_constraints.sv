class c_5_1;
    int UART_BASE_ADDRESS = 536870912;
    rand bit[2:0] req_adr_i; // rand_mode = ON 

    constraint WITH_CONSTRAINT_this    // (constraint_mode = ON) (../wishbone/sv/wishbone_sequences.sv:488)
    {
       (req_adr_i == (UART_BASE_ADDRESS + (4 * 1)));
    }
endclass

program p_5_1;
    c_5_1 obj;
    string randState;

    initial
        begin
            obj = new;
            randState = "1z1zx0zxxx0xx11x01x0zx1zzx1zzx1zxzzxxzxzzxxxxxzzzzxxxxzxxzxzzxxz";
            obj.set_randstate(randState);
            obj.randomize();
        end
endprogram
