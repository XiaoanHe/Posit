module fpadder (
    input clk,
    input rst,
    input [31:0] x,
    input [31:0] y,
    output reg [31:0] z,
    output reg [1:0] overflow//0-没有溢出;1-上溢;10-下溢;11-输入不是规格化数
);
    reg [24:0] m_x,m_y,m_z; 
    reg [7:0] exponent_x,exponent_y,exponent_z;
    reg [2:0] state_now,state_next;
    reg sign_z,sign_x,sign_y;

    reg [24:0] out_x,out_y,mid_y,mid_x;
    reg [7:0] move_tot;
    reg [2:0] bigger;

    parameter start = 3'b000,zerocheck = 3'b001,equalcheck = 3'b010,addm = 3'b011,normal = 3'b100,over = 3'b110;

    always @(posedge clk) begin
        if(!rst)begin
            state_now<=start;
        end
        else begin
            state_now<=state_next;
        end
    end
    
    always @(state_now,state_next,exponent_x,exponent_y,exponent_z,m_x,m_y,m_z,out_x,out_y,mid_x,mid_y) begin
        case(state_now)
            start:begin//分离指数和尾数 
                bigger<=2'b0;
                exponent_x<=x[30:23];
                exponent_y<=y[30:23];
                m_x<={1'b0,1'b1,x[22:0]};//最高位来控制溢出 1.F
                m_y<={1'b0,1'b1,y[22:0]};
                out_x<=25'b0;
                out_y<=25'b0;
                mid_y<={24'b0,1'b1};
                mid_x<={24'b0,1'b1};
                move_tot<=8'b0;
                //只有阶码[1,254]和实数0是规格化数字
                if((exponent_x==8'd255&&m_x[22:0]!=0)||(exponent_y==8'd255&&m_y[22:0]!=0))begin//出现了NaN，任意数+NaN=NaN
                    overflow<=2'b11;    
                    state_next<=over;
                    sign_z<=1'b1;
                    exponent_z<=8'b11111111;
                    m_z<=23'b11111111111111111111111;
                end
                else if((exponent_x==8'd255&&m_x[22:0]==0)||(exponent_y==8'd255&&m_y[22:0]==0))begin//出现了无穷大，结果必然是无穷大
                    overflow<=2'b11;    
                    state_next<=over;
                    sign_z<=1'b0;
                    exponent_z<=8'b11111111;
                    m_z<=23'b0;
                    // z<=32'h7F800000;
                end
                // else if((exponent_x==8'd0&&m_x[22:0]!=23'b0)||(exponent_y==8'd0&&m_y[22:0]!=23'b0))begin
                //     overflow<=2'b11; 
                //     state_next<=over;
                //     sign_z<=1'b1;
                //     exponent_z<=8'b11111111;
                //     m_z<=23'b11111111111111111111111;
                //     z<=32'hFFFFFFFF;//直接将结果赋值为非规约数，然后回到start阶段
                // end
                else begin
                    // if(exponent_x==8'd0&&m_x[22:0]!=23'b0)begin
                    //     m_x<={1'b0,1'b0,x[22:0]};
                    // end
                    // if(exponent_y==8'd0&&m_y[22:0]!=23'b0)begin
                    //     m_y<={1'b0,1'b0,y[22:0]};
                    // end
                    overflow<=2'b0;
                    state_next<=zerocheck;//进入判断0 阶段
                end
            end
            zerocheck:begin//x==0||y==0,则直接进入over
                if(m_x[22:0]==23'b0&&exponent_x==8'b0)begin
                    sign_z<=y[31];
                    exponent_z<=exponent_y;
                    m_z<=m_y;
                    state_next<=over;
                end
                else if(m_y[22:0]==23'b0&&exponent_y==8'b0)begin
                    sign_z<=x[31];
                    exponent_z<=exponent_x;
                    m_z<=m_x;
                    state_next<=over;
                end
                else begin
                    state_next<=equalcheck;//进入 对阶处理阶段
                end
                if(m_x[22:0]!=23'b0&&exponent_x==8'b0)begin
                    m_x<={1'b0,1'b0,x[22:0]};
                end
                if(m_y[22:0]!=23'b0&&exponent_y==8'b0)begin
                    m_y<={1'b0,1'b0,y[22:0]};
                end
            end
            equalcheck:begin//对阶处理 需要在移位的时候进行向偶舍入
                if(exponent_x==exponent_y)begin
                    if(bigger==2'b00)begin
                        state_next<=addm;//指数对齐，进入尾数加阶段
                    end
                    else if(bigger==2'b10)begin
                        if(out_y>mid_y)begin
                            m_y<=m_y+1'b1;
                        end
                        else if(out_y<mid_y)begin
                            m_y<=m_y;
                        end
                        else if(out_y==mid_y)begin
                            if(m_y[0]==1)begin
                                m_y<=m_y+1'b1;
                            end
                            else begin
                                m_y<=m_y;
                            end
                        end    
                        state_next<=addm;
                    end
                    else if(bigger==2'b01)begin
                        if(out_x>mid_x)begin
                            m_x<=m_x+1'b1;
                        end
                        else if(out_x<mid_x)begin
                            m_x<=m_x;
                        end
                        else if(out_x==mid_x)begin
                            if(m_x[0]==1)begin
                                m_x<=m_x+1'b1;
                            end
                            else begin
                                m_x<=m_x;
                            end
                        end     
                        state_next<=addm;
                    end
                end
                else begin
                    if(exponent_x>exponent_y)begin
                        bigger<=2'b01;
                        exponent_y<=exponent_y+1'b1;
                        m_y[23:0]<={1'b0,m_y[23:1]};//指数+1，尾数右移一位
                        out_y[move_tot]<=m_y[0];
                        mid_y={mid_y[23:0],mid_y[24]};
                        move_tot<=move_tot+1'b1;
                        if(m_y==24'b0)begin//如果x和y的节码差距过大，就不需要考虑太小的
                            sign_z<=sign_x;
                            exponent_z<=exponent_x;
                            m_z<=m_x;
                            state_next<=over;
                        end
                        else begin
                            state_next<=equalcheck;
                        end
                    end
                    else begin
                        bigger<=2'b10;
                        exponent_x<=exponent_x+1'b1;
                        m_x[23:0]<={1'b0,m_x[23:1]};//指数+1，尾数右移一位
                        out_x[move_tot]<=m_x[0];
                        mid_x={mid_x[23:0],mid_x[24]};
                        move_tot<=move_tot+1'b1;
                        if(m_x==24'b0)begin//如果x和y的节码差距过大，就不需要考虑太小的
                            sign_z<=sign_y;
                            exponent_z<=exponent_y;
                            m_z<=m_y;
                            state_next<=over;
                        end
                        else begin
                            state_next<=equalcheck;
                        end
                    end
                end
            end
            addm:begin
                if(x[31]^y[31]==1'b0)begin
                    exponent_z<=exponent_x;
                    sign_z<=x[31];
                    m_z<=m_x+m_y;
                    state_next<=normal;
                end
                else begin
                    if(m_x>m_y)begin
                        exponent_z<=exponent_x;
                        sign_z<=x[31];
                        m_z<=m_x-m_y;
                        state_next<=normal;
                    end
                    else if(m_x<m_y)begin
                        exponent_z<=exponent_x;
                        sign_z<=y[31];
                        m_z<=m_y-m_x;
                        state_next<=normal;
                    end
                    else begin
                        exponent_z<=exponent_x;
                        m_z<=23'b0;
                        state_next<=over;//全零没必要规格化
                    end
                end
                // if(m_z[23:0]==24'b0)begin//全零没必要规格化
                //     state_next<=over;
                // end
                // else begin
                //     state_next<=normal;
                // end
            end
            normal:begin
                if(m_z[24]==1'b1)begin
                    // 有进位/借位
                    m_z<={1'b0,m_z[24:1]};
                    exponent_z<=exponent_z+1'b1;
                    state_next<=over;
                end
                else begin
                    if(m_z[23]==1'b0&&exponent_z>=1)begin//规格化处理，0.xxxx转化成1.xxxxx
                        m_z<={m_z[23:0],1'b0};
                        exponent_z<=exponent_z-1'b1;
                        state_next<=normal;
                    end
                    else begin
                        state_next<=over;
                    end
                end
            end
            over:begin
                z={sign_z,exponent_z[7:0],m_z[22:0]};
                //判断溢出：
                //1.大于最大浮点数
                //2.小于最小浮点数(这部分本身是非规约数)，直接输出z，标记出它是下溢出
                if(overflow)begin
                    overflow<=overflow;
                    state_next<=start;
                end
                else if(exponent_z==8'd255)begin
                    overflow<=2'b01;
                    state_next<=start;
                end
                else if(exponent_z==8'd0&&m_z[22:0]!=23'b0)begin
                    overflow<=2'b10;
                    state_next<=start;
                end
                else begin
                    overflow<=2'b00;
		            state_next<=start;
                end 
            end
            default:begin
                state_next<=start;
            end
        endcase
    end
endmodule
