<<<<<<< HEAD
function[isensors]= F_sensor_DG_r(U, p)

    [n,r]=size(U);
    THETApp=zeros(p,r);
    THETAppTHETApptinv=zeros(p,p);
    abs=zeros(1,n);
    tmp=zeros(1,r);
    sensor=zeros(1,p);

    for pp=1:p
        Y=eye(r)-THETApp(1:pp-1,:)'*THETAppTHETApptinv(1:pp-1,1:pp-1)*THETApp(1:pp-1,:);
        for nn=1:n
            tmp(1,:)=U(nn,:);
            abs(nn)=tmp(1,:)*Y*tmp(1,:)';
        end

    [~,sensor(pp)]=max(abs);
    THETApp(pp,:)=U(sensor(pp),:);
    THETAppTHETApptinv(1:pp,1:pp)=inv(THETApp(1:pp,:)*THETApp(1:pp,:)');
    U(sensor(pp),:) = zeros(1,r);
    end
    isensors=sensor';
    
=======
function[isensors]= F_sensor_DG_r(U, p)

    [n,r]=size(U);
    THETApp=zeros(p,r);
    THETAppTHETApptinv=zeros(p,p);
    abs=zeros(1,n);
    tmp=zeros(1,r);
    sensor=zeros(1,p);

    for pp=1:p
        Y=eye(r)-THETApp(1:pp-1,:)'*THETAppTHETApptinv(1:pp-1,1:pp-1)*THETApp(1:pp-1,:);
        for nn=1:n
            tmp(1,:)=U(nn,:);
            abs(nn)=tmp(1,:)*Y*tmp(1,:)';
        end

    [~,sensor(pp)]=max(abs);
    THETApp(pp,:)=U(sensor(pp),:);
    THETAppTHETApptinv(1:pp,1:pp)=inv(THETApp(1:pp,:)*THETApp(1:pp,:)');
    U(sensor(pp),:) = zeros(1,r);
    end
    isensors=sensor';
    
>>>>>>> 6150b0a6442ac2200723bae0ca9384e6c5610ed9
end