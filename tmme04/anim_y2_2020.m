function anim_y2_2020 (t,beta,theta,phi,l,t_scale)
%Animation routine for computer assignment in Mekanik Y, del 2.
%Input:
%Vector beta, theta and phi holding the values of "beta", "theta" and "phi" for the instants of time
%given in the vector t (output from ode45).
%l is the length of the bars with mass m1 and m2.
%t_scale determines the time scale of the animation. t_scale=1 implies that
%the animation is done without changing the time scale. t_scale=10
%implies that the animation will take 10 times *longer*.






%Clear current figure:
clf

%Calculate coordinates of point C:
x_c=l*cos(beta);
y_c=l*sin(beta);

%Calculate coordinates of free end point of bar m2:
x_e=x_c+l*sin(phi);
y_e=y_c-l*cos(phi);



%Calculate coordinates of point D:
x_b=-l*cos(beta);
y_b=-l*sin(beta);

%Calculate coordinates of free end point of bar m1:
x_d=x_b+l*sin(theta);
y_d=y_b-l*cos(theta);


axis equal
axis([-2.1*l,2.1 *l, -2.1 *l,2.1 *l])  



l0=line([0 0.1 -0.1 0],[0 -0.1 -0.1 0],'LineWidth',2,'Color','Black');

l1=line([x_b(1) x_c(1)],[y_b(1) y_c(1)],'LineWidth',2);
l2=line([x_b(1) x_d(1)],[y_b(1) y_d(1)],'LineWidth',2,'Color','Green');
l3=line([x_c(1) x_e(1)],[y_c(1) y_e(1)],'LineWidth',2,'Color','Red');

t1=text(1.4*l,1.95*l,['Tid: ' num2str(t(1),'%4.1f')]);



t0=clock;
for i=2:length(t)
    l1.XData=[x_b(i) x_c(i)];
    l1.YData=[y_b(i) y_c(i)];
    l2.XData=[x_b(i) x_d(i)];
    l2.YData=[y_b(i) y_d(i)];
    l3.XData=[x_c(i) x_e(i)];
    l3.YData=[y_c(i) y_e(i)];
    
    t1.String=['Tid: ' num2str(t(i),'%4.1f')];
    
    while etime(clock,t0)<t_scale*t(i),end %Wait to plot until t_scale*t(i) seconds have
                                           %elapsed since start of animation. 
    drawnow update
    
end



