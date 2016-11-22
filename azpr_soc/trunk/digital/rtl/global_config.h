`ifndef __GLOBAL_CONFIG_HEADER__
    
    `ifdef ACTIVE_HIGH
        `define POSITIVE_RESET
            `define RESET_EDGE      posedge
            `define RESET_ENABLE    1'b1
            `define RESET_DISABLE   1'b0
        `define POSITIVE_MEMORY
            `define MEM_ENABLE      1'b1
            `define MEM_DISABLE     1'b0
        `
    `elsif ACTIVE_LOW
        `define NEGATIVE_RESET
            `define RESET_EDGE      negedge
            `define RESET_ENABLE    1'b0
            `define RESET_DISABLE   1'b1
        `define NEGATIVE_MEMORY
            `define MEM_ENABLE      1'b0
            `define MEM_DISABLE     1'b1
            
    `endif
    //io select 

    `define IMPLEMENT_TIMER
    `define IMPLEMENT_UART
    `define IMPLEMENT_GPIO


`endif
