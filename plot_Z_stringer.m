function plot_Z_stringer(b, d, h, t, ts, str, b_type)
% function that plots Z-shaped stringers provided:
% b = Stringer Pitch
% d = Stringer Flange Width
% h = Stringer Web
% t = Skin Thickness
% ts = Stringer Thickness
% str = String argument for title - Root, Kink & Tip
% b_type = String argument for spacing type variable or constant b


% Skin Lines
n=1000;
x1=linspace(0,(b+d)*2,n);
y1=@(x1) ts+h;
y2=@(x1) ts+t+h;
color = 'k';

% 1st Stringer (left)
y3=linspace(h,ts+h,n);
x3=@(y3) 0;

x4=linspace(d-0.5*ts,2*d,n);
y4=@(x6) 0;

y5=linspace(ts,h+ts,n);
x5=@(x9) d+ts*0.5;
 
x6=linspace(0,d-0.5*ts,n);
y6=@(x4) h;

y7=linspace(0,h,n);
x7=@(y5) d-0.5*ts;

x8=linspace(0.5*ts+d,2*d,n);
y8=@(x8) ts;

y9=linspace(0,ts,n);
x9=@(y7) 2*d;

% 2nd stringer (center)
y10=linspace(ts,h+ts,n);
x10=@(x16) b+d+ts*0.5;

x11=linspace(b,b+d-0.5*ts,n);
y11=@(x11) h;

y12=linspace(0,ts,n);
x12=@(y14) b+2*d;
 
x13=linspace(b+d-0.5*ts,b+2*d,n);
y13=@(x13) 0;

y14=linspace(0,h,n);
x14=@(y12)b+d-0.5*ts;

x15=linspace(b+d+0.5*ts,b+2*d,n);
y15=@(x15) ts;

y16=linspace(h,ts+h,n);
x16=@(y10) b;

% 3rd stringer (right)
y17=linspace(h,ts+h,n);
x17=@(y17) 2*b;
 
x18=linspace(2*b,2*b+d-0.5*ts,n);
y18=@(x18) h;

y19=linspace(h+ts,h+t+ts,n);
x19=@(y24) 2*(b+d);

x20=linspace(2*b+d+0.5*ts,2*b+2*d,n);
y20=@(x22) ts;

y21=linspace(0,ts,n);
x21=@(y21) 2*b+2*d;

x22=linspace(2*b+d-0.5*ts,2*b+2*d,n);
y22=@(x20) 0;
 
y23=linspace(ts,h+ts,n);
x23=@(x23) 2*b+d+ts*0.5;

y24=linspace(0,h,n);
x24=@(y19)2*b+d-0.5*ts;


for i =1:n
    y1_plot(i)=y1(x1(i));
    y2_plot(i)=y2(x1(i));
    x3_plot(i)=x3(y3(i));
    y4_plot(i)=y4(x4(i));
    x5_plot(i)=x5(y5(i));
    y6_plot(i)=y6(x6(i));
    x7_plot(i)=x7(y7(i));
    y8_plot(i)=y8(x8(i));
    x9_plot(i)=x9(y9(i));
    x10_plot(i)=x10(y10(i));
    y11_plot(i)=y11(x11(i));
    x12_plot(i)=x12(y12(i));
    y13_plot(i)=y13(x13(i));
    x14_plot(i)=x14(y14(i));
    y15_plot(i)=y15(x15(i));
    x16_plot(i)=x16(y16(i));
    x17_plot(i)=x17(y17(i));
    y18_plot(i)=y18(x18(i));
    x19_plot(i)=x19(y19(i));
    y20_plot(i)=y20(x20(i));
    x21_plot(i)=x21(y21(i));
    y22_plot(i)=y22(x22(i));
    x23_plot(i)=x23(y23(i));
    x24_plot(i)=x24(y24(i));
end 
    
% Plotting complete configuration
    plot(x1,y1_plot,color)
    hold on 
    plot(x1,y2_plot,color)
    hold on 
    plot(x3_plot,y3,color)
    hold on 
    plot(x4,y4_plot,color)
    hold on 
    plot(x5_plot,y5,color)
    hold on 
    plot(x6,y6_plot,color)
    hold on 
    plot(x7_plot,y7,color)
    hold on 
    plot(x8,y8_plot,color)
    hold on 
    plot(x9_plot,y9,color)
    hold on
    plot(x10_plot,y10,color)
    hold on 
    plot(x11,y11_plot,color)
    hold on 
    plot(x12_plot,y12,color)
    hold on 
    plot(x13,y13_plot,color)
    hold on 
    plot(x14_plot,y14,color)
    hold on 
    plot(x15,y15_plot,color)
    hold on 
    plot(x16_plot,y16,color)
    hold on
    plot(x17_plot,y17,color)
    hold on 
    plot(x18,y18_plot,color)
    hold on 
    plot(x19_plot,y19,color)
    hold on 
    plot(x20,y20_plot,color)
    hold on 
    plot(x21_plot,y21,color)
    hold on 
    plot(x22,y22_plot,color)
    hold on 
    plot(x23_plot,y23,color)
    hold on
    plot(x24_plot,y24,color)
    hold off
    
    axis equal;
    xlabel('[m]');
    ylabel('[m]');
    title(sprintf('%s - %s b', str, b_type));
end
