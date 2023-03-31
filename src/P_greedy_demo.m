<<<<<<< HEAD
%% Main program
%% ///////////////////////////////////////////////////////////////////
% Comments:
% 	Collaborator: Yuji Saito, Keigo Yamada, Taku Nonomura
%                 Kumi Nakai, Takayuki Nagata
% 	Last modified: 2021/9/27
% Nomenclature:
% - Scalars
%   n : Number of degrees of freedom of spatial POD modes (state dimension)
%   p : Number of sensors
%   r : Number of rank for truncated POD
%   m : Number of snaphot (temporal dimension)
%   Matrices
% 	X : Supervising data matrix
% 	Y : Observation matrix
% 	H : Sparse sensor location matrix
% 	U : Spatial POD modes matrix
% 	C : Measurement matrix
% 	Z : POD mode amplitude matrix
%% ===================================================================

clear; close all;
warning('off','all')
% rng(1)

%% Selection of Problems ============================================
  num_problem=1; % //Randomized sensor problem//
% num_problem=2; % //NOAA-SST//
% !<NOAA-SST> It takes a long time to obtain the solution in the convex 
% !<NOAA-SST> approximation method and the convex method is commented out 
% !<NOAA_SST> as default setting for reduction of demo time.
%
%% Parameters =======================================================
r = 10;
pmin = 20;
pinc = 1;
pmax = 20;
ps   = pmin:pinc:pmax;
% ps = 20;
Lmax = 50; % choose Lmax so that Lmax is not less than the no. of objective functions
Rmax = 2;
num_ave = 2;%100; % Number of iteration for averaging operation
CNT = 0; % Counter
maxiteration = 10; % Max iteration for convex approximation
% //Randomized sensor problem//
n   = 1000;%5000;
ns  = 100;
pov = 100;%500;
% //NOAA-SST//
m = 500;
num_video = 10; % maxmum: m

%% Preparation of output directories ================================
workdir   = ('../work');
mkdir(workdir);
if num_problem == 2
    videodir  = [workdir,'/video'];
    sensordir = [workdir,'/sensor_location'];
    mkdir(videodir);
    mkdir(sensordir);
end

%% Randomized sensor problem ========================================
if num_problem == 1

    %% Sensor selection =============================================
    for p = ps
        CNT = CNT+1;
        text = [ num2str(p),' sensor selection started --->' ];
        disp(text);

        %% Average loop =============================================
        % rng(1,'twister');
        for w=1:1:num_ave
            if mod(w,num_ave/10) == 0
                disp(['ave: ',num2str(w),'/',num2str(num_ave)]);
            end

            %% Preprocess for Randomized problem ====================
            rng(w,'twister');
            U = randn(n,r);
            % filename = [workdir, '/U_L',num2str(Lmax),'_aveloop',num2str(w),'.mat'];
            % save(filename,'U');

            %% Random selection -------------------------------------
            [time_rand(CNT,w+1), H_rand, sensors_rand] = F_sensor_random(n,p);
            det_rand (CNT,w+1) = F_calc_det  (p,H_rand,U);
            tr_rand  (CNT,w+1) = F_calc_trace(p,H_rand,U);
            eig_rand (CNT,w+1) = F_calc_eigen(p,H_rand,U);

            %% D-optimality - Hybrid of QR and DG -------------------
            [time_QD(CNT,w+1), H_QD, sensors_QD] = F_sensor_QD(U,p);
            det_QD (CNT,w+1) = F_calc_det  (p,H_QD,U);
            tr_QD  (CNT,w+1) = F_calc_trace(p,H_QD,U);
            eig_QD (CNT,w+1) = F_calc_eigen(p,H_QD,U);
            % % dummy ---
            % time_QD(CNT,w+1) = time_rand(CNT,w+1);
            % det_QD (CNT,w+1) = det_rand (CNT,w+1);
            % tr_QD  (CNT,w+1) = tr_rand  (CNT,w+1);
            % eig_QD (CNT,w+1) = eig_rand (CNT,w+1);
            % H_QD = H_rand;
            % sensors_QD = sensors_rand;

            %% A-optimality -  Greedy -------------------------------
            [time_AG(CNT,w+1), H_AG, sensors_AG] = F_sensor_AG(U,p);
            det_AG (CNT,w+1) = F_calc_det  (p,H_AG,U);
            tr_AG  (CNT,w+1) = F_calc_trace(p,H_AG,U);
            eig_AG (CNT,w+1) = F_calc_eigen(p,H_AG,U);
            % % dummy ---
            % time_AG(CNT,w+1) = time_rand(CNT,w+1);
            % det_AG (CNT,w+1) = det_rand (CNT,w+1);
            % tr_AG  (CNT,w+1) = tr_rand  (CNT,w+1);
            % eig_AG (CNT,w+1) = eig_rand (CNT,w+1);
            % H_AG = H_rand;
            % sensors_AG = sensors_rand;

            %% E-optimality -  Greedy -------------------------------
            [time_EG(CNT,w+1), H_EG, sensors_EG] = F_sensor_EG(U,p);
            det_EG (CNT,w+1) = F_calc_det  (p,H_EG,U);
            tr_EG  (CNT,w+1) = F_calc_trace(p,H_EG,U);
            eig_EG (CNT,w+1) = F_calc_eigen(p,H_EG,U);
            % % dummy ---
            % time_EG(CNT,w+1) = time_rand(CNT,w+1);
            % det_EG (CNT,w+1) = det_rand (CNT,w+1);
            % tr_EG  (CNT,w+1) = tr_rand  (CNT,w+1);
            % eig_EG (CNT,w+1) = eig_rand (CNT,w+1);
            % H_EG = H_rand;
            % sensors_EG = sensors_rand;

            %% Nondominated-solution-based multiobjective Greedy ----
            [time_NMG(CNT,w+1), sensors_NMG, fND, time_NMG_separate] = F_sensor_NMG(U,p,Lmax,Rmax,2);
            %det_NMG (CNT,w+1) = F_calc_det  (p,H_NMG,U);
            %tr_NMG  (CNT,w+1) = F_calc_trace(p,H_NMG,U);
            %eig_NMG (CNT,w+1) = F_calc_eigen(p,H_NMG,U);
            [det_NMG(CNT,w+1), Ldet] = min(fND(:,p+1));
            [tr_NMG(CNT,w+1),  Ltr ] = min(fND(:,p+2));
            [eig_NMG(CNT,w+1), Leig] = min(fND(:,p+3));
            det_NMG(CNT,w+1) = -det_NMG(CNT,w+1);
            eig_NMG(CNT,w+1) = -eig_NMG(CNT,w+1);
            % dummy ---
            % time_NMG(CNT,w+1) = time_rand(CNT,w+1);
            % det_NMG (CNT,w+1) = det_rand (CNT,w+1);
            % tr_NMG  (CNT,w+1) = tr_rand  (CNT,w+1);
            % eig_NMG (CNT,w+1) = eig_rand (CNT,w+1);
            % H_NMG = H_rand;
            % sensors_NMG = sensors_rand;
            % Ldet = 1;
            % Ltr = 1;
            % Leig = 1;

            %% Nondominated-solution-based multiobjective Greedy ----
%             [time_NMG2(CNT,w+1), sensors_NMG2, fND2, time_NMG2_separate] = F_sensor_NMG(U,p,Lmax,Rmax,4);
%             %det_NMG (CNT,w+1) = F_calc_det  (p,H_NMG,U);
%             %tr_NMG  (CNT,w+1) = F_calc_trace(p,H_NMG,U);
%             %eig_NMG (CNT,w+1) = F_calc_eigen(p,H_NMG,U);
%             [det_NMG2(CNT,w+1), Ldet2] = min(fND(:,p+1));
%             [tr_NMG2(CNT,w+1),  Ltr2 ] = min(fND(:,p+2));
%             [eig_NMG2(CNT,w+1), Leig2] = min(fND(:,p+3));
%             det_NMG2(CNT,w+1) = -det_NMG2(CNT,w+1);
%             eig_NMG2(CNT,w+1) = -eig_NMG2(CNT,w+1);
            % dummy ---
            time_NMG2(CNT,w+1) = time_rand(CNT,w+1);
            det_NMG2 (CNT,w+1) = det_rand (CNT,w+1);
            tr_NMG2  (CNT,w+1) = tr_rand  (CNT,w+1);
            eig_NMG2 (CNT,w+1) = eig_rand (CNT,w+1);
            H_NMG2 = H_rand;
            sensors_NMG2 = sensors_rand;
            Ldet2 = 1;
            Ltr2 = 1;
            Leig2 = 1;
            
            %% D-optimality - Group greedy (GDG)
%             [time_GDG(CNT,w+1), H_GDG, sensors_GDG, ~] ...
%             = F_sensor_GDG(U,p,Lmax);
%             det_GDG (CNT,w+1) = F_calc_det  (p,H_GDG,U);
%             tr_GDG  (CNT,w+1) = F_calc_trace(p,H_GDG,U);
%             eig_GDG (CNT,w+1) = F_calc_eigen(p,H_GDG,U);
            % dummy ---
            time_GDG(CNT,w+1) = time_rand(CNT,w+1);
            det_GDG (CNT,w+1) = det_rand (CNT,w+1);
            tr_GDG  (CNT,w+1) = tr_rand  (CNT,w+1);
            eig_GDG (CNT,w+1) = eig_rand (CNT,w+1);
            H_GDG = H_rand;
            sensors_GDG = sensors_rand;
            
            %% D-optimality - Randomized group greedy (RGDG)
%             [time_RGDG(CNT,w+1), H_RGDG, sensors_RGDG, ~] ...
%             = F_sensor_RGDG(U,p,Lmax,ns);
%             det_RGDG (CNT,w+1) = F_calc_det  (p,H_RGDG,U);
%             tr_RGDG  (CNT,w+1) = F_calc_trace(p,H_RGDG,U);
%             eig_RGDG (CNT,w+1) = F_calc_eigen(p,H_RGDG,U);
            % dummy ---
            time_RGDG(CNT,w+1) = time_rand(CNT,w+1);
            det_RGDG (CNT,w+1) = det_rand (CNT,w+1);
            tr_RGDG  (CNT,w+1) = tr_rand  (CNT,w+1);
            eig_RGDG (CNT,w+1) = eig_rand (CNT,w+1);
            H_RGDG = H_rand;
            sensors_RGDG = sensors_rand;

            %% D-optimality - Elite and randomized group greedy (ERGDG)
%             [time_ERGDG(CNT,w+1), H_ERGDG, sensors_ERGDG, ~] ...
%             = F_sensor_ERGDG(U,p,Lmax,ns,pov);
%             det_ERGDG (CNT,w+1) = F_calc_det  (p,H_ERGDG,U);
%             tr_ERGDG  (CNT,w+1) = F_calc_trace(p,H_ERGDG,U);
%             eig_ERGDG (CNT,w+1) = F_calc_eigen(p,H_ERGDG,U);
            % dummy ---
            time_ERGDG(CNT,w+1) = time_rand(CNT,w+1);
            det_ERGDG (CNT,w+1) = det_rand (CNT,w+1);
            tr_ERGDG  (CNT,w+1) = tr_rand  (CNT,w+1);
            eig_ERGDG (CNT,w+1) = eig_rand (CNT,w+1);
            H_ERGDG = H_rand;
            sensors_ERGDG = sensors_rand;

            %% E-optimality - Group greedy (GEG)
%             [time_GEG(CNT,w+1), H_GEG, sensors_GEG, ~] ...
%             = F_sensor_GEG(U,p,Lmax);
%             det_GEG (CNT,w+1) = F_calc_det  (p,H_GEG,U);
%             tr_GEG  (CNT,w+1) = F_calc_trace(p,H_GEG,U);
%             eig_GEG (CNT,w+1) = F_calc_eigen(p,H_GEG,U);
            % dummy ---
            time_GEG(CNT,w+1) = time_rand(CNT,w+1);
            det_GEG (CNT,w+1) = det_rand (CNT,w+1);
            tr_GEG  (CNT,w+1) = tr_rand  (CNT,w+1);
            eig_GEG (CNT,w+1) = eig_rand (CNT,w+1);
            H_GEG = H_rand;
            sensors_GEG = sensors_rand;

            %% E-optimality - Randomized group greedy (RGEG)
%             [time_RGEG(CNT,w+1), H_RGEG, sensors_RGEG, ~] ...
%             = F_sensor_RGEG(U,p,Lmax,ns);
%             det_RGEG (CNT,w+1) = F_calc_det  (p,H_RGEG,U);
%             tr_RGEG  (CNT,w+1) = F_calc_trace(p,H_RGEG,U);
%             eig_RGEG (CNT,w+1) = F_calc_eigen(p,H_RGEG,U);
            % dummy ---
            time_RGEG(CNT,w+1) = time_rand(CNT,w+1);
            det_RGEG (CNT,w+1) = det_rand (CNT,w+1);
            tr_RGEG  (CNT,w+1) = tr_rand  (CNT,w+1);
            eig_RGEG (CNT,w+1) = eig_rand (CNT,w+1);
            H_RGEG = H_rand;
            sensors_RGEG = sensors_rand;

            %% E-optimality - Elite and randomized group greedy (ERGEG)
%             [time_ERGEG(CNT,w+1), H_ERGEG, sensors_ERGEG, ~] ...
%             = F_sensor_ERGEG(U,p,Lmax,ns,pov);
%             det_ERGEG (CNT,w+1) = F_calc_det  (p,H_ERGEG,U);
%             tr_ERGEG  (CNT,w+1) = F_calc_trace(p,H_ERGEG,U);
%             eig_ERGEG (CNT,w+1) = F_calc_eigen(p,H_ERGEG,U);
            % dummy ---
            time_ERGEG(CNT,w+1) = time_rand(CNT,w+1);
            det_ERGEG (CNT,w+1) = det_rand (CNT,w+1);
            tr_ERGEG  (CNT,w+1) = tr_rand  (CNT,w+1);
            eig_ERGEG (CNT,w+1) = eig_rand (CNT,w+1);
            H_ERGEG = H_rand;
            sensors_ERGEG = sensors_rand;

            %% A-optimality - Group greedy (GAG)
%             [time_GAG(CNT,w+1), H_GAG, sensors_GAG, ~] ...
%             = F_sensor_GAG(U,p,Lmax);
%             det_GAG (CNT,w+1) = F_calc_det  (p,H_GAG,U);
%             tr_GAG  (CNT,w+1) = F_calc_trace(p,H_GAG,U);
%             eig_GAG (CNT,w+1) = F_calc_eigen(p,H_GAG,U);
            % % dummy ---
            time_GAG(CNT,w+1) = time_rand(CNT,w+1);
            det_GAG (CNT,w+1) = det_rand (CNT,w+1);
            tr_GAG  (CNT,w+1) = tr_rand  (CNT,w+1);
            eig_GAG (CNT,w+1) = eig_rand (CNT,w+1);
            H_GAG = H_rand;
            sensors_GAG = sensors_rand;

        end
        
        %% Averaging ================================================
        [ time_rand, det_rand, tr_rand, eig_rand ]...
        = F_data_ave1( CNT, num_ave, time_rand, det_rand, tr_rand, eig_rand );
        [ time_QD, det_QD, tr_QD, eig_QD ]...
        = F_data_ave1( CNT, num_ave, time_QD, det_QD, tr_QD, eig_QD );
        [ time_AG, det_AG, tr_AG, eig_AG ]...
        = F_data_ave1( CNT, num_ave, time_AG, det_AG, tr_AG, eig_AG );
        [ time_EG, det_EG, tr_EG, eig_EG ]...
        = F_data_ave1( CNT, num_ave, time_EG, det_EG, tr_EG, eig_EG );
        [ time_NMG, det_NMG, tr_NMG, eig_NMG ]...
        = F_data_ave1( CNT, num_ave, time_NMG, det_NMG, tr_NMG, eig_NMG );
        [ time_NMG2, det_NMG2, tr_NMG2, eig_NMG2 ]...
        = F_data_ave1( CNT, num_ave, time_NMG2, det_NMG2, tr_NMG2, eig_NMG2 );
        [ time_GDG, det_GDG, tr_GDG, eig_GDG ]...
        = F_data_ave1( CNT, num_ave, time_GDG, det_GDG, tr_GDG, eig_GDG );
        [ time_RGDG, det_RGDG, tr_RGDG, eig_RGDG ]...
        = F_data_ave1( CNT, num_ave, time_RGDG, det_RGDG, tr_RGDG, eig_RGDG );
        [ time_ERGDG, det_ERGDG, tr_ERGDG, eig_ERGDG ]...
        = F_data_ave1( CNT, num_ave, time_ERGDG, det_ERGDG, tr_ERGDG, eig_ERGDG );
        [ time_GEG, det_GEG, tr_GEG, eig_GEG ]...
        = F_data_ave1( CNT, num_ave, time_GEG, det_GEG, tr_GEG, eig_GEG );
        [ time_RGEG, det_RGEG, tr_RGEG, eig_RGEG ]...
        = F_data_ave1( CNT, num_ave, time_RGEG, det_RGEG, tr_RGEG, eig_RGEG );
        [ time_ERGEG, det_ERGEG, tr_ERGEG, eig_ERGEG ]...
        = F_data_ave1( CNT, num_ave, time_ERGEG, det_ERGEG, tr_ERGEG, eig_ERGEG );
        [ time_GAG, det_GAG, tr_GAG, eig_GAG ]...
        = F_data_ave1( CNT, num_ave, time_GAG, det_GAG, tr_GAG, eig_GAG );
        % NT_TOL_cal_DC(CNT,1)=mean(NT_TOL_cal_DC(CNT,2:w+1));
        % iter_DC(CNT,1)=mean(iter_DC(CNT,2:w+1));
        
        %% Sensor location ==========================================
        sensor_memo = zeros(p,17);
        sensor_memo(1:p,1) = sensors_rand(1:p)';
        sensor_memo(1:p,2) = sensors_QD(1:p)';
        sensor_memo(1:p,3) = sensors_AG(1:p)';
        sensor_memo(1:p,4) = sensors_EG(1:p); %remove ' 2021/3/12
        sensor_memo(1:p,5) = sensors_NMG(Ldet,1:p)';
        sensor_memo(1:p,6) = sensors_NMG(Ltr, 1:p)';
        sensor_memo(1:p,7) = sensors_NMG(Leig,1:p)';
        sensor_memo(1:p,8) = sensors_NMG2(Ldet2,1:p)';
        sensor_memo(1:p,9) = sensors_NMG2(Ltr2, 1:p)';
        sensor_memo(1:p,10) = sensors_NMG2(Leig2,1:p)';
        sensor_memo(1:p,11) = sensors_GDG(1,1:p)';
        sensor_memo(1:p,12) = sensors_RGDG(1,1:p)';
        sensor_memo(1:p,13) = sensors_ERGDG(1,1:p)';
        sensor_memo(1:p,14) = sensors_GEG(1,1:p)';
        sensor_memo(1:p,15) = sensors_RGEG(1,1:p)';
        sensor_memo(1:p,16) = sensors_ERGEG(1,1:p)';
        sensor_memo(1:p,17) = sensors_GAG(1,1:p)';
        % % dummy ---
        % sensor_memo(1:p,5) = sensor_memo(1:p,1);
        % sensor_memo(1:p,6) = sensor_memo(1:p,1);
        % sensor_memo(1:p,7) = sensor_memo(1:p,1);
        % sensor_memo(1:p,8)  = sensor_memo(1:p,1);
        % sensor_memo(1:p,9)  = sensor_memo(1:p,1);
        % sensor_memo(1:p,10) = sensor_memo(1:p,1);
        % sensor_memo(1:p,11) = sensor_memo(1:p,1);
        % sensor_memo(1:p,12) = sensor_memo(1:p,1);
        % sensor_memo(1:p,13) = sensor_memo(1:p,1);
        % sensor_memo(1:p,14) = sensor_memo(1:p,1);

        filename = [workdir, '/sensors_p_', num2str(p), '.mat'];
        save(filename,'sensor_memo');

        % filename = [workdir, '/fND_p_', num2str(p), '.mat'];
        % save(filename,'fND');

        text = [ '---> ', num2str(p), ' sensor selection finished!' ];
        disp(text);
    end
    filename = [workdir, '/fND_NMG1_p_', num2str(p), '.mat'];
    save(filename,'fND');
%     filename = [workdir, '/fND_NMG2_p_', num2str(p), '.mat'];
%     save(filename,'fND2');
end

%% NOAA-SST =========================================================
if num_problem == 2

    %% Preprocces for NOAA-SST ======================================
    text='Readinng/Arranging a NOAA-SST dataset';
    disp(text);
    [Lat, Lon, time, mask, sst]...
    = F_pre_read_NOAA_SST( ['sst.wkmean.1990-present.nc'], ['lsmask.nc'] );
    [Uorg, Sorg, Vorg, Xorg, meansst, n] = F_pre_SVD_NOAA_SST(m, time, mask, sst);
    F_map_original(num_video, Xorg, meansst, mask, time, videodir);
    [U, Error_ave_pod, Error_std_pod]...
    = F_pre_truncatedSVD(r, Xorg, Uorg, Sorg, Vorg, num_video, meansst, mask, time, m, videodir);
    Error_ave_pod = repmat( Error_ave_pod , size(ps,2) );
    text='Complete Reading/Arranging a NOAA-SST dataset!';
    disp(text);

    %% Sensor selection =============================================
    for p = ps
        CNT = CNT+1;
        text = [ num2str(p),' sensor selection started --->' ];
        disp(text);

        %% Random selection -----------------------------------------
        % Average loop
        for w=1:1:num_ave
            [time_rand(CNT,w+1), H_rand, sensors_rand] = F_sensor_random(n,p);
            det_rand(CNT,w+1) = F_calc_det  (p,H_rand,U);
            tr_rand (CNT,w+1) = F_calc_trace(p,H_rand,U);
            eig_rand(CNT,w+1) = F_calc_eigen(p,H_rand,U);
            [Zestimate_rand, Error_rand(CNT,w+1), Error_std_rand(CNT,w+1)] ...
            = F_calc_error(m, Xorg, U, H_rand);
        end
        % Averaging
        [ time_rand, det_rand, tr_rand, eig_rand, Error_rand, Error_std_rand ]...
        = F_data_ave2( CNT, num_ave, time_rand, det_rand, tr_rand, eig_rand, Error_rand, Error_std_rand );

        %% D-optimality - Convex-------------------------------------
        %!! This is very time consuming proceduce, We do not recommend to try this
        % [time_DC(CNT,1), H_DC, sensors_DC, ...
        %  NT_TOL_cal_DC(CNT,1), iter_DC(CNT,1)] ...
        %  = F_sensor_DC(U,p,maxiteration);
        % det_DC(CNT,1) = F_calc_det(p,H_DC,U);
        % tr_DC(CNT,1)  = F_calc_trace(p,H_DC,U);
        % eig_DC(CNT,1) = F_calc_eigen(p,H_DC,U);
        %!! I recommend you use the following dummy values 
        %   if you do not need the solution in the convex approximation in NOAA-SST.
        time_DC(CNT,1) = time_rand(CNT,1);
        det_DC (CNT,1) = det_rand (CNT,1);
        tr_DC  (CNT,1) = tr_rand  (CNT,1);
        eig_DC (CNT,1) = eig_rand (CNT,1);
        H_DC=H_rand;
        sensors_DC=sensors_rand;
        NT_TOL_cal_DC(CNT,w+1)=0;
        iter_DC(CNT,w+1)=0;
        %!!
        [Zestimate_DC, Error_DC(CNT,1), Error_std_DC(CNT,1)] ...
        = F_calc_error(m, Xorg, U, H_DC);
        NT_TOL_cal_DC(CNT,1)=mean(NT_TOL_cal_DC(CNT,2:w+1));
        iter_DC(CNT,1)=mean(iter_DC(CNT,2:w+1));
        
        % %% Maximization of row norm - Greedy based on QR ------------
        % [time_QR(CNT,1), H_QR, sensors_QR] = F_sensor_QR(U,p);
        % det_QR (CNT,1) = F_calc_det  (p,H_QR,U);
        % tr_QR  (CNT,1) = F_calc_trace(p,H_QR,U);
        % eig_QR (CNT,1) = F_calc_eigen(p,H_QR,U);
        % [Zestimate_QR, Error_QR(CNT,1), Error_std_QR(CNT,1)] ...
        % = F_calc_error(m, Xorg, U, H_QR);

        % %% D-optimality - Greedy ------------------------------------
        % [time_DG(CNT,1), H_DG, sensors_DG] = F_sensor_DG(U,p);
        % det_DG (CNT,1) = F_calc_det  (p,H_DG,U);
        % tr_DG  (CNT,1) = F_calc_trace(p,H_DG,U);
        % eig_DG (CNT,1) = F_calc_eigen(p,H_DG,U);
        % [Zestimate_DG, Error_DG(CNT,1), Error_std_DG(CNT,1)] ...
        % = F_calc_error(m, Xorg, U, H_DG);

        %% D-optimality - Hybrid of QR and DG -----------------------
        [time_QD(CNT,1), H_QD, sensors_QD] = F_sensor_QD(U,p);
        det_QD (CNT,1) = F_calc_det  (p,H_QD,U);
        tr_QD  (CNT,1) = F_calc_trace(p,H_QD,U);
        eig_QD (CNT,1) = F_calc_eigen(p,H_QD,U);
        [Zestimate_QD, Error_QD(CNT,1), Error_std_QD(CNT,1)] ...
        = F_calc_error(m, Xorg, U, H_QD);

        %% A-optimality -  Greedy -----------------------------------
        [time_AG(CNT,1), H_AG, sensors_AG] = F_sensor_AG(U,p);
        det_AG (CNT,1) = F_calc_det  (p,H_AG,U);
        tr_AG  (CNT,1) = F_calc_trace(p,H_AG,U);
        eig_AG (CNT,1) = F_calc_eigen(p,H_AG,U);
        [Zestimate_AG, Error_AG(CNT,1), Error_std_AG(CNT,1)] ...
        = F_calc_error(m, Xorg, U, H_AG);

        %% E-optimality -  Greedy -----------------------------------
        [time_EG(CNT,1), H_EG, sensors_EG] = F_sensor_EG(U,p);
        det_EG (CNT,1) = F_calc_det  (p,H_EG,U);
        tr_EG  (CNT,1) = F_calc_trace(p,H_EG,U);
        eig_EG (CNT,1) = F_calc_eigen(p,H_EG,U);
        [Zestimate_EG, Error_EG(CNT,1), Error_std_EG(CNT,1)] ...
        = F_calc_error(m, Xorg, U, H_EG);

        %% Nondominated-solution-based multiobjective Greedy --------
        [time_NMG(CNT,1), sensors_NMG, fND] = F_sensor_NMG(U,p,Lmax,Rmax);
        %det_NMG (CNT,1) = F_calc_det  (p,H_NMG,U);
        %tr_NMG  (CNT,1) = F_calc_trace(p,H_NMG,U);
        %eig_NMG (CNT,1) = F_calc_eigen(p,H_NMG,U);
        % det_NMG  (CNT,1) = - min(fND(:,p+1));
        % tr_NMG   (CNT,1) =   min(fND(:,p+2));
        % eig_NMG  (CNT,1) = - min(fND(:,p+3));
        [det_NMG(CNT,1), Ldet] = min(fND(:,p+1));
        [tr_NMG(CNT,1),  Ltr ] = min(fND(:,p+2));
        [eig_NMG(CNT,1), Leig] = min(fND(:,p+3));
        det_NMG = -det_NMG;
        eig_NMG = -eig_NMG;
        H_NMG_det = F_calc_sensormatrix(p, n, sensors_NMG(Ldet,:));
        H_NMG_tr  = F_calc_sensormatrix(p, n, sensors_NMG(Ltr ,:));
        H_NMG_eig = F_calc_sensormatrix(p, n, sensors_NMG(Leig,:));
        [Zestimate_NMG_det, Error_NMG_det(CNT,1), Error_std_NMG_det(CNT,1)] ...
        = F_calc_error(m, Xorg, U, H_NMG_det);
        [Zestimate_NMG_tr, Error_NMG_tr(CNT,1), Error_std_NMG_tr(CNT,1)] ...
        = F_calc_error(m, Xorg, U, H_NMG_tr);
        [Zestimate_NMG_eig, Error_NMG_eig(CNT,1), Error_std_NMG_eig(CNT,1)] ...
        = F_calc_error(m, Xorg, U, H_NMG_eig);

        %% Sensor location ==========================================
        sensor_memo = zeros(p,8);
        sensor_memo(1:p,1) = sensors_rand(1:p)';
        sensor_memo(1:p,3) = sensors_QD(1:p)';
        sensor_memo(1:p,4) = sensors_AG(1:p)';
        sensor_memo(1:p,5) = sensors_EG(1:p); %remove ' 2021/3/12
        sensor_memo(1:p,6) = sensors_NMG(Ldet,1:p)';
        sensor_memo(1:p,7) = sensors_NMG(Ltr, 1:p)';
        sensor_memo(1:p,8) = sensors_NMG(Leig,1:p)';
        sensor_memo(1:p,6)  = sensors_GDG(1:p);
        sensor_memo(1:p,7)  = sensors_RGDG(1:p);
        sensor_memo(1:p,8)  = sensors_ERGDG(1:p);
        sensor_memo(1:p,10) = sensors_GEG(1:p);
        sensor_memo(1:p,11) = sensors_RGEG(1:p);
        sensor_memo(1:p,12) = sensors_ERGEG(1:p);
        sensor_memo(1:p,10) = sensors_GAG(1:p);
        filename = [workdir, '/sensors_p_', num2str(p), '.mat'];
        save(filename,'sensor_memo');

        %% Video ====================================================
        name='rand';
        F_map_reconst(r, num_video, Xorg, meansst, U, mask, time, p, ...
                        sensors_rand, Zestimate_rand, name, videodir, sensordir)
        name='QD';
        F_map_reconst(r, num_video, Xorg, meansst, U, mask, time, p, ...
                        sensors_QD, Zestimate_QD, name, videodir, sensordir)
        name='AG';
        F_map_reconst(r, num_video, Xorg, meansst, U, mask, time, p, ...
                        sensors_AG, Zestimate_AG, name, videodir, sensordir)
        name='EG';
        F_map_reconst(r, num_video, Xorg, meansst, U, mask, time, p, ...
                        sensors_EG, Zestimate_EG, name, videodir, sensordir)
        name='NMG_det';
        F_map_reconst(r, num_video, Xorg, meansst, U, mask, time, p, ...
                        sensors_NMG(Ldet,1:p), Zestimate_NMG_det, name, videodir, sensordir)
        name='NMG_tr';
        F_map_reconst(r, num_video, Xorg, meansst, U, mask, time, p, ...
                        sensors_NMG(Ltr ,1:p), Zestimate_NMG_tr, name, videodir, sensordir)
        name='NMG_eig';
        F_map_reconst(r, num_video, Xorg, meansst, U, mask, time, p, ...
                        sensors_NMG(Leig,1:p), Zestimate_NMG_eig, name, videodir, sensordir)
        
        text = [ '---> ', num2str(p), ' sensor selection finished!' ];
        disp(text);
    end
end

%% Data organization ================================================
% Arrange
[time_all] = F_data_arrange1( ps, CNT,    time_rand, time_QD,...
                              time_AG,    time_EG,   time_NMG,...
                              time_NMG2, ...
                              time_GDG,  time_RGDG, time_ERGDG,...
                              time_GEG,  time_RGEG, time_ERGEG,...
                              time_GAG );
[det_all]  = F_data_arrange1( ps, CNT, det_rand, det_QD,...
                              det_AG,  det_EG,   det_NMG,...
                              det_NMG2, ...
                              det_GDG, det_RGDG, det_ERGDG,...
                              det_GEG, det_RGEG, det_ERGEG,...
                              det_GAG );
[tr_all]   = F_data_arrange1( ps, CNT, tr_rand, tr_QD,...
                              tr_AG,   tr_EG,   tr_NMG,...
                              tr_NMG2, ...
                              tr_GDG,  tr_RGDG, tr_ERGDG,...
                              tr_GEG,  tr_RGEG, tr_ERGEG,...
                              tr_GAG );
[eig_all]  = F_data_arrange1( ps, CNT, eig_rand, eig_QD,...
                              eig_AG,  eig_EG,   eig_NMG,...
                              eig_NMG2, ...
                              eig_GDG, eig_RGDG, eig_ERGDG,...
                              eig_GEG, eig_RGEG, eig_ERGEG,...
                              eig_GAG);
if num_problem == 2
    [Error] = F_data_arrange2( ps,         CNT, ...
                               Error_rand, Error_std_rand, ...
                               Error_DC,   Error_std_DC,   ...
                               Error_QD,   Error_std_QD,   ...
                               Error_AG,   Error_std_AG,   ...
                               Error_EG,   Error_std_EG,   ...
                               Error_NMG_det, Error_std_NMG_det, ...
                               Error_NMG_tr,  Error_std_NMG_tr,  ...
                               Error_NMG_eig, Error_std_NMG_eig, ...
                               Error_ave_pod );
end
% [log_DC] = F_data_arrange3( ps, CNT, NT_TOL_cal_DC, iter_DC );

% Normalize
[Normalized_det] = F_data_normalize( ps, CNT, det_rand, det_QD, ...
                                     det_AG,  det_EG,   det_NMG,...
                                     det_NMG2, ...
                                     det_GDG, det_RGDG, det_ERGDG,...
                                     det_GEG, det_RGEG, det_ERGEG,...
                                     det_GAG, det_QD );
[Normalized_det2]= F_data_normalize( ps, CNT, det_rand, det_QD, ...
                                     det_AG,  det_EG,   det_NMG,...
                                     det_NMG2, ...
                                     det_GDG, det_RGDG, det_ERGDG,...
                                     det_GEG, det_RGEG, det_ERGEG,...
                                     det_GAG, det_AG );
[Normalized_det3]= F_data_normalize( ps, CNT, det_rand, det_QD, ...
                                     det_AG,  det_EG,   det_NMG,...
                                     det_NMG2, ...
                                     det_GDG, det_RGDG, det_ERGDG,...
                                     det_GEG, det_RGEG, det_ERGEG,...
                                     det_GAG, det_EG );
[Normalized_tr]  = F_data_normalize( ps, CNT, tr_rand,  tr_QD, ...
                                     tr_AG,   tr_EG,    tr_NMG,...
                                     tr_NMG2, ...
                                     tr_GDG,  tr_RGDG, tr_ERGDG,...
                                     tr_GEG,  tr_RGEG, tr_ERGEG,...
                                     tr_GAG,  tr_QD );
[Normalized_tr2] = F_data_normalize( ps, CNT, tr_rand,  tr_QD, ...
                                     tr_AG,   tr_EG,    tr_NMG,...
                                     tr_NMG2, ...
                                     tr_GDG,  tr_RGDG, tr_ERGDG,...
                                     tr_GEG,  tr_RGEG, tr_ERGEG,...
                                     tr_GAG,  tr_AG );
[Normalized_tr3] = F_data_normalize( ps, CNT, tr_rand,  tr_QD, ...
                                     tr_AG,   tr_EG,    tr_NMG,...
                                     tr_NMG2, ...
                                     tr_GDG,  tr_RGDG, tr_ERGDG,...
                                     tr_GEG,  tr_RGEG, tr_ERGEG,...
                                     tr_GAG,  tr_EG );
[Normalized_eig] = F_data_normalize( ps, CNT, eig_rand, eig_QD, ...
                                     eig_AG,  eig_EG,   eig_NMG,...
                                     eig_NMG2,...
                                     eig_GDG, eig_RGDG, eig_ERGDG,...
                                     eig_GEG, eig_RGEG, eig_ERGEG,...
                                     eig_GAG, eig_QD );
[Normalized_eig2] = F_data_normalize( ps, CNT, eig_rand, eig_QD, ...
                                     eig_AG,  eig_EG,   eig_NMG,...
                                     eig_NMG2,...
                                     eig_GDG, eig_RGDG, eig_ERGDG,...
                                     eig_GEG, eig_RGEG, eig_ERGEG,...
                                     eig_GAG, eig_AG );
[Normalized_eig3]= F_data_normalize( ps, CNT, eig_rand, eig_QD, ...
                                     eig_AG,  eig_EG,   eig_NMG,...
                                     eig_NMG2,...
                                     eig_GDG, eig_RGDG, eig_ERGDG,...
                                     eig_GEG, eig_RGEG, eig_ERGEG,...
                                     eig_GAG, eig_EG );

%% Save =============================================================
cd(workdir)
save('time.mat','time_all');
save('det.mat','det_all');
save('trace.mat','tr_all');
save('eigen.mat','eig_all');
save('Normalized_det_basedQD.mat','Normalized_det');
save('Normalized_det_basedAG.mat','Normalized_det2');
save('Normalized_det_basedEG.mat','Normalized_det3');
save('Normalized_trace_basedQD.mat','Normalized_tr');
save('Normalized_trace_basedAG.mat','Normalized_tr2');
save('Normalized_trace_basedEG.mat','Normalized_tr3');
save('Normalized_eigen_basedQD.mat','Normalized_eig');
save('Normalized_eigen_basedAG.mat','Normalized_eig2');
save('Normalized_eigen_basedEG.mat','Normalized_eig3');
save('time_rand.mat','time_rand');
save('det_rand.mat','det_rand');
save('trace_rand.mat','tr_rand');
save('eigen_rand.mat','eig_rand');
if num_problem == 1
    save('time_QD.mat',    'time_QD');
    save('time_AG.mat',    'time_AG');
    save('time_EG.mat',    'time_EG');
    save('time_NMG.mat',   'time_NMG');
    save('time_NMG2.mat',  'time_NMG2');
    save('time_NMG_separate.mat','time_NMG_separate');
%     save('time_NMG2_separate.mat','time_NMG2_separate');
    save('time_GDG.mat',   'time_GDG');
    save('time_RGDG.mat',  'time_RGDG');
    save('time_ERGDG.mat', 'time_ERGDG');
    save('time_GEG.mat',   'time_GEG');
    save('time_EGEG.mat',  'time_RGEG');
    save('time_ERGEG.mat', 'time_ERGEG');
    save('time_GAG.mat',   'time_GAG');
    save('det_QD.mat',    'det_QD');
    save('det_AG.mat',    'det_AG');
    save('det_EG.mat',    'det_EG');
    save('det_NMG.mat',   'det_NMG');
    save('det_NMG2.mat',  'det_NMG2');
    save('det_GDG.mat',   'det_GDG');
    save('det_RGDG.mat',  'det_RGDG');
    save('det_ERGDG.mat', 'det_ERGDG');
    save('det_GEG.mat',   'det_GEG');
    save('det_RGEG.mat',  'det_RGEG');
    save('det_ERGEG.mat', 'det_ERGEG');
    save('det_GAG.mat',   'det_GAG');
    save('tr_QD.mat',    'tr_QD');
    save('tr_AG.mat',    'tr_AG');
    save('tr_EG.mat',    'tr_EG');
    save('tr_NMG.mat',   'tr_NMG');
    save('tr_NMG2.mat',  'tr_NMG2');
    save('tr_GDG.mat',   'tr_GDG');
    save('tr_RGDG.mat',  'tr_RGDG');
    save('tr_ERGDG.mat', 'tr_ERGDG');
    save('tr_GEG.mat',   'tr_GEG');
    save('tr_RGEG.mat',  'tr_RGEG');
    save('tr_ERGEG.mat', 'tr_ERGEG');
    save('tr_GAG.mat',   'tr_GAG');
    save('eig_QD.mat',   'eig_QD');
    save('eig_AG.mat',   'eig_AG');
    save('eig_EG.mat',   'eig_EG');
    save('eig_NMG.mat',  'eig_NMG');
    save('eig_NMG2.mat', 'eig_NMG2');
    save('eig_GDG.mat',  'eig_GDG');
    save('eig_RGDG.mat', 'eig_RGDG');
    save('eig_ERGDG.mat','eig_ERGDG');
    save('eig_GEG.mat',  'eig_GEG');
    save('eig_RGEG.mat', 'eig_RGEG');
    save('eig_ERGEG.mat','eig_ERGEG');
    save('eig_GAG.mat',  'eig_GAG');
end
if num_problem == 2
    save('Error.mat','Error');
    save('Error_rand.mat','Error_rand');
end
% save('log_DC.mat','log_DC');

warning('on','all')
disp('Congratulations!');
cd ../src
%% ///////////////////////////////////////////////////////////////////
=======
%% Main program
%% ///////////////////////////////////////////////////////////////////
% Comments:
% 	Collaborator: Yuji Saito, Keigo Yamada, Taku Nonomura
%                 Kumi Nakai, Takayuki Nagata
% 	Last modified: 2021/9/27
% Nomenclature:
% - Scalars
%   n : Number of degrees of freedom of spatial POD modes (state dimension)
%   p : Number of sensors
%   r : Number of rank for truncated POD
%   m : Number of snaphot (temporal dimension)
%   Matrices
% 	X : Supervising data matrix
% 	Y : Observation matrix
% 	H : Sparse sensor location matrix
% 	U : Spatial POD modes matrix
% 	C : Measurement matrix
% 	Z : POD mode amplitude matrix
%% ===================================================================

clear; close all;
warning('off','all')
% rng(1)

%% Selection of Problems ============================================
  num_problem=1; % //Randomized sensor problem//
% num_problem=2; % //NOAA-SST//
% !<NOAA-SST> It takes a long time to obtain the solution in the convex 
% !<NOAA-SST> approximation method and the convex method is commented out 
% !<NOAA_SST> as default setting for reduction of demo time.
%
%% Parameters =======================================================
r = 10;
pmin = 20;
pinc = 1;
pmax = 20;
ps   = pmin:pinc:pmax;
% ps = 20;
Lmax = 50; % choose Lmax so that Lmax is not less than the no. of objective functions
Rmax = 2;
num_ave = 2;%100; % Number of iteration for averaging operation
CNT = 0; % Counter
maxiteration = 10; % Max iteration for convex approximation
% //Randomized sensor problem//
n   = 1000;%5000;
ns  = 100;
pov = 100;%500;
% //NOAA-SST//
m = 500;
num_video = 10; % maxmum: m

%% Preparation of output directories ================================
workdir   = ('../work');
mkdir(workdir);
if num_problem == 2
    videodir  = [workdir,'/video'];
    sensordir = [workdir,'/sensor_location'];
    mkdir(videodir);
    mkdir(sensordir);
end

%% Randomized sensor problem ========================================
if num_problem == 1

    %% Sensor selection =============================================
    for p = ps
        CNT = CNT+1;
        text = [ num2str(p),' sensor selection started --->' ];
        disp(text);

        %% Average loop =============================================
        % rng(1,'twister');
        for w=1:1:num_ave
            if mod(w,num_ave/10) == 0
                disp(['ave: ',num2str(w),'/',num2str(num_ave)]);
            end

            %% Preprocess for Randomized problem ====================
            rng(w,'twister');
            U = randn(n,r);
            % filename = [workdir, '/U_L',num2str(Lmax),'_aveloop',num2str(w),'.mat'];
            % save(filename,'U');

            %% Random selection -------------------------------------
            [time_rand(CNT,w+1), H_rand, sensors_rand] = F_sensor_random(n,p);
            det_rand (CNT,w+1) = F_calc_det  (p,H_rand,U);
            tr_rand  (CNT,w+1) = F_calc_trace(p,H_rand,U);
            eig_rand (CNT,w+1) = F_calc_eigen(p,H_rand,U);

            %% D-optimality - Hybrid of QR and DG -------------------
            [time_QD(CNT,w+1), H_QD, sensors_QD] = F_sensor_QD(U,p);
            det_QD (CNT,w+1) = F_calc_det  (p,H_QD,U);
            tr_QD  (CNT,w+1) = F_calc_trace(p,H_QD,U);
            eig_QD (CNT,w+1) = F_calc_eigen(p,H_QD,U);
            % % dummy ---
            % time_QD(CNT,w+1) = time_rand(CNT,w+1);
            % det_QD (CNT,w+1) = det_rand (CNT,w+1);
            % tr_QD  (CNT,w+1) = tr_rand  (CNT,w+1);
            % eig_QD (CNT,w+1) = eig_rand (CNT,w+1);
            % H_QD = H_rand;
            % sensors_QD = sensors_rand;

            %% A-optimality -  Greedy -------------------------------
            [time_AG(CNT,w+1), H_AG, sensors_AG] = F_sensor_AG(U,p);
            det_AG (CNT,w+1) = F_calc_det  (p,H_AG,U);
            tr_AG  (CNT,w+1) = F_calc_trace(p,H_AG,U);
            eig_AG (CNT,w+1) = F_calc_eigen(p,H_AG,U);
            % % dummy ---
            % time_AG(CNT,w+1) = time_rand(CNT,w+1);
            % det_AG (CNT,w+1) = det_rand (CNT,w+1);
            % tr_AG  (CNT,w+1) = tr_rand  (CNT,w+1);
            % eig_AG (CNT,w+1) = eig_rand (CNT,w+1);
            % H_AG = H_rand;
            % sensors_AG = sensors_rand;

            %% E-optimality -  Greedy -------------------------------
            [time_EG(CNT,w+1), H_EG, sensors_EG] = F_sensor_EG(U,p);
            det_EG (CNT,w+1) = F_calc_det  (p,H_EG,U);
            tr_EG  (CNT,w+1) = F_calc_trace(p,H_EG,U);
            eig_EG (CNT,w+1) = F_calc_eigen(p,H_EG,U);
            % % dummy ---
            % time_EG(CNT,w+1) = time_rand(CNT,w+1);
            % det_EG (CNT,w+1) = det_rand (CNT,w+1);
            % tr_EG  (CNT,w+1) = tr_rand  (CNT,w+1);
            % eig_EG (CNT,w+1) = eig_rand (CNT,w+1);
            % H_EG = H_rand;
            % sensors_EG = sensors_rand;

            %% Nondominated-solution-based multiobjective Greedy ----
            [time_NMG(CNT,w+1), sensors_NMG, fND, time_NMG_separate] = F_sensor_NMG(U,p,Lmax,Rmax,2);
            %det_NMG (CNT,w+1) = F_calc_det  (p,H_NMG,U);
            %tr_NMG  (CNT,w+1) = F_calc_trace(p,H_NMG,U);
            %eig_NMG (CNT,w+1) = F_calc_eigen(p,H_NMG,U);
            [det_NMG(CNT,w+1), Ldet] = min(fND(:,p+1));
            [tr_NMG(CNT,w+1),  Ltr ] = min(fND(:,p+2));
            [eig_NMG(CNT,w+1), Leig] = min(fND(:,p+3));
            det_NMG(CNT,w+1) = -det_NMG(CNT,w+1);
            eig_NMG(CNT,w+1) = -eig_NMG(CNT,w+1);
            % dummy ---
            % time_NMG(CNT,w+1) = time_rand(CNT,w+1);
            % det_NMG (CNT,w+1) = det_rand (CNT,w+1);
            % tr_NMG  (CNT,w+1) = tr_rand  (CNT,w+1);
            % eig_NMG (CNT,w+1) = eig_rand (CNT,w+1);
            % H_NMG = H_rand;
            % sensors_NMG = sensors_rand;
            % Ldet = 1;
            % Ltr = 1;
            % Leig = 1;

            %% Nondominated-solution-based multiobjective Greedy ----
%             [time_NMG2(CNT,w+1), sensors_NMG2, fND2, time_NMG2_separate] = F_sensor_NMG(U,p,Lmax,Rmax,4);
%             %det_NMG (CNT,w+1) = F_calc_det  (p,H_NMG,U);
%             %tr_NMG  (CNT,w+1) = F_calc_trace(p,H_NMG,U);
%             %eig_NMG (CNT,w+1) = F_calc_eigen(p,H_NMG,U);
%             [det_NMG2(CNT,w+1), Ldet2] = min(fND(:,p+1));
%             [tr_NMG2(CNT,w+1),  Ltr2 ] = min(fND(:,p+2));
%             [eig_NMG2(CNT,w+1), Leig2] = min(fND(:,p+3));
%             det_NMG2(CNT,w+1) = -det_NMG2(CNT,w+1);
%             eig_NMG2(CNT,w+1) = -eig_NMG2(CNT,w+1);
            % dummy ---
            time_NMG2(CNT,w+1) = time_rand(CNT,w+1);
            det_NMG2 (CNT,w+1) = det_rand (CNT,w+1);
            tr_NMG2  (CNT,w+1) = tr_rand  (CNT,w+1);
            eig_NMG2 (CNT,w+1) = eig_rand (CNT,w+1);
            H_NMG2 = H_rand;
            sensors_NMG2 = sensors_rand;
            Ldet2 = 1;
            Ltr2 = 1;
            Leig2 = 1;
            
            %% D-optimality - Group greedy (GDG)
%             [time_GDG(CNT,w+1), H_GDG, sensors_GDG, ~] ...
%             = F_sensor_GDG(U,p,Lmax);
%             det_GDG (CNT,w+1) = F_calc_det  (p,H_GDG,U);
%             tr_GDG  (CNT,w+1) = F_calc_trace(p,H_GDG,U);
%             eig_GDG (CNT,w+1) = F_calc_eigen(p,H_GDG,U);
            % dummy ---
            time_GDG(CNT,w+1) = time_rand(CNT,w+1);
            det_GDG (CNT,w+1) = det_rand (CNT,w+1);
            tr_GDG  (CNT,w+1) = tr_rand  (CNT,w+1);
            eig_GDG (CNT,w+1) = eig_rand (CNT,w+1);
            H_GDG = H_rand;
            sensors_GDG = sensors_rand;
            
            %% D-optimality - Randomized group greedy (RGDG)
%             [time_RGDG(CNT,w+1), H_RGDG, sensors_RGDG, ~] ...
%             = F_sensor_RGDG(U,p,Lmax,ns);
%             det_RGDG (CNT,w+1) = F_calc_det  (p,H_RGDG,U);
%             tr_RGDG  (CNT,w+1) = F_calc_trace(p,H_RGDG,U);
%             eig_RGDG (CNT,w+1) = F_calc_eigen(p,H_RGDG,U);
            % dummy ---
            time_RGDG(CNT,w+1) = time_rand(CNT,w+1);
            det_RGDG (CNT,w+1) = det_rand (CNT,w+1);
            tr_RGDG  (CNT,w+1) = tr_rand  (CNT,w+1);
            eig_RGDG (CNT,w+1) = eig_rand (CNT,w+1);
            H_RGDG = H_rand;
            sensors_RGDG = sensors_rand;

            %% D-optimality - Elite and randomized group greedy (ERGDG)
%             [time_ERGDG(CNT,w+1), H_ERGDG, sensors_ERGDG, ~] ...
%             = F_sensor_ERGDG(U,p,Lmax,ns,pov);
%             det_ERGDG (CNT,w+1) = F_calc_det  (p,H_ERGDG,U);
%             tr_ERGDG  (CNT,w+1) = F_calc_trace(p,H_ERGDG,U);
%             eig_ERGDG (CNT,w+1) = F_calc_eigen(p,H_ERGDG,U);
            % dummy ---
            time_ERGDG(CNT,w+1) = time_rand(CNT,w+1);
            det_ERGDG (CNT,w+1) = det_rand (CNT,w+1);
            tr_ERGDG  (CNT,w+1) = tr_rand  (CNT,w+1);
            eig_ERGDG (CNT,w+1) = eig_rand (CNT,w+1);
            H_ERGDG = H_rand;
            sensors_ERGDG = sensors_rand;

            %% E-optimality - Group greedy (GEG)
%             [time_GEG(CNT,w+1), H_GEG, sensors_GEG, ~] ...
%             = F_sensor_GEG(U,p,Lmax);
%             det_GEG (CNT,w+1) = F_calc_det  (p,H_GEG,U);
%             tr_GEG  (CNT,w+1) = F_calc_trace(p,H_GEG,U);
%             eig_GEG (CNT,w+1) = F_calc_eigen(p,H_GEG,U);
            % dummy ---
            time_GEG(CNT,w+1) = time_rand(CNT,w+1);
            det_GEG (CNT,w+1) = det_rand (CNT,w+1);
            tr_GEG  (CNT,w+1) = tr_rand  (CNT,w+1);
            eig_GEG (CNT,w+1) = eig_rand (CNT,w+1);
            H_GEG = H_rand;
            sensors_GEG = sensors_rand;

            %% E-optimality - Randomized group greedy (RGEG)
%             [time_RGEG(CNT,w+1), H_RGEG, sensors_RGEG, ~] ...
%             = F_sensor_RGEG(U,p,Lmax,ns);
%             det_RGEG (CNT,w+1) = F_calc_det  (p,H_RGEG,U);
%             tr_RGEG  (CNT,w+1) = F_calc_trace(p,H_RGEG,U);
%             eig_RGEG (CNT,w+1) = F_calc_eigen(p,H_RGEG,U);
            % dummy ---
            time_RGEG(CNT,w+1) = time_rand(CNT,w+1);
            det_RGEG (CNT,w+1) = det_rand (CNT,w+1);
            tr_RGEG  (CNT,w+1) = tr_rand  (CNT,w+1);
            eig_RGEG (CNT,w+1) = eig_rand (CNT,w+1);
            H_RGEG = H_rand;
            sensors_RGEG = sensors_rand;

            %% E-optimality - Elite and randomized group greedy (ERGEG)
%             [time_ERGEG(CNT,w+1), H_ERGEG, sensors_ERGEG, ~] ...
%             = F_sensor_ERGEG(U,p,Lmax,ns,pov);
%             det_ERGEG (CNT,w+1) = F_calc_det  (p,H_ERGEG,U);
%             tr_ERGEG  (CNT,w+1) = F_calc_trace(p,H_ERGEG,U);
%             eig_ERGEG (CNT,w+1) = F_calc_eigen(p,H_ERGEG,U);
            % dummy ---
            time_ERGEG(CNT,w+1) = time_rand(CNT,w+1);
            det_ERGEG (CNT,w+1) = det_rand (CNT,w+1);
            tr_ERGEG  (CNT,w+1) = tr_rand  (CNT,w+1);
            eig_ERGEG (CNT,w+1) = eig_rand (CNT,w+1);
            H_ERGEG = H_rand;
            sensors_ERGEG = sensors_rand;

            %% A-optimality - Group greedy (GAG)
%             [time_GAG(CNT,w+1), H_GAG, sensors_GAG, ~] ...
%             = F_sensor_GAG(U,p,Lmax);
%             det_GAG (CNT,w+1) = F_calc_det  (p,H_GAG,U);
%             tr_GAG  (CNT,w+1) = F_calc_trace(p,H_GAG,U);
%             eig_GAG (CNT,w+1) = F_calc_eigen(p,H_GAG,U);
            % % dummy ---
            time_GAG(CNT,w+1) = time_rand(CNT,w+1);
            det_GAG (CNT,w+1) = det_rand (CNT,w+1);
            tr_GAG  (CNT,w+1) = tr_rand  (CNT,w+1);
            eig_GAG (CNT,w+1) = eig_rand (CNT,w+1);
            H_GAG = H_rand;
            sensors_GAG = sensors_rand;

        end
        
        %% Averaging ================================================
        [ time_rand, det_rand, tr_rand, eig_rand ]...
        = F_data_ave1( CNT, num_ave, time_rand, det_rand, tr_rand, eig_rand );
        [ time_QD, det_QD, tr_QD, eig_QD ]...
        = F_data_ave1( CNT, num_ave, time_QD, det_QD, tr_QD, eig_QD );
        [ time_AG, det_AG, tr_AG, eig_AG ]...
        = F_data_ave1( CNT, num_ave, time_AG, det_AG, tr_AG, eig_AG );
        [ time_EG, det_EG, tr_EG, eig_EG ]...
        = F_data_ave1( CNT, num_ave, time_EG, det_EG, tr_EG, eig_EG );
        [ time_NMG, det_NMG, tr_NMG, eig_NMG ]...
        = F_data_ave1( CNT, num_ave, time_NMG, det_NMG, tr_NMG, eig_NMG );
        [ time_NMG2, det_NMG2, tr_NMG2, eig_NMG2 ]...
        = F_data_ave1( CNT, num_ave, time_NMG2, det_NMG2, tr_NMG2, eig_NMG2 );
        [ time_GDG, det_GDG, tr_GDG, eig_GDG ]...
        = F_data_ave1( CNT, num_ave, time_GDG, det_GDG, tr_GDG, eig_GDG );
        [ time_RGDG, det_RGDG, tr_RGDG, eig_RGDG ]...
        = F_data_ave1( CNT, num_ave, time_RGDG, det_RGDG, tr_RGDG, eig_RGDG );
        [ time_ERGDG, det_ERGDG, tr_ERGDG, eig_ERGDG ]...
        = F_data_ave1( CNT, num_ave, time_ERGDG, det_ERGDG, tr_ERGDG, eig_ERGDG );
        [ time_GEG, det_GEG, tr_GEG, eig_GEG ]...
        = F_data_ave1( CNT, num_ave, time_GEG, det_GEG, tr_GEG, eig_GEG );
        [ time_RGEG, det_RGEG, tr_RGEG, eig_RGEG ]...
        = F_data_ave1( CNT, num_ave, time_RGEG, det_RGEG, tr_RGEG, eig_RGEG );
        [ time_ERGEG, det_ERGEG, tr_ERGEG, eig_ERGEG ]...
        = F_data_ave1( CNT, num_ave, time_ERGEG, det_ERGEG, tr_ERGEG, eig_ERGEG );
        [ time_GAG, det_GAG, tr_GAG, eig_GAG ]...
        = F_data_ave1( CNT, num_ave, time_GAG, det_GAG, tr_GAG, eig_GAG );
        % NT_TOL_cal_DC(CNT,1)=mean(NT_TOL_cal_DC(CNT,2:w+1));
        % iter_DC(CNT,1)=mean(iter_DC(CNT,2:w+1));
        
        %% Sensor location ==========================================
        sensor_memo = zeros(p,17);
        sensor_memo(1:p,1) = sensors_rand(1:p)';
        sensor_memo(1:p,2) = sensors_QD(1:p)';
        sensor_memo(1:p,3) = sensors_AG(1:p)';
        sensor_memo(1:p,4) = sensors_EG(1:p); %remove ' 2021/3/12
        sensor_memo(1:p,5) = sensors_NMG(Ldet,1:p)';
        sensor_memo(1:p,6) = sensors_NMG(Ltr, 1:p)';
        sensor_memo(1:p,7) = sensors_NMG(Leig,1:p)';
        sensor_memo(1:p,8) = sensors_NMG2(Ldet2,1:p)';
        sensor_memo(1:p,9) = sensors_NMG2(Ltr2, 1:p)';
        sensor_memo(1:p,10) = sensors_NMG2(Leig2,1:p)';
        sensor_memo(1:p,11) = sensors_GDG(1,1:p)';
        sensor_memo(1:p,12) = sensors_RGDG(1,1:p)';
        sensor_memo(1:p,13) = sensors_ERGDG(1,1:p)';
        sensor_memo(1:p,14) = sensors_GEG(1,1:p)';
        sensor_memo(1:p,15) = sensors_RGEG(1,1:p)';
        sensor_memo(1:p,16) = sensors_ERGEG(1,1:p)';
        sensor_memo(1:p,17) = sensors_GAG(1,1:p)';
        % % dummy ---
        % sensor_memo(1:p,5) = sensor_memo(1:p,1);
        % sensor_memo(1:p,6) = sensor_memo(1:p,1);
        % sensor_memo(1:p,7) = sensor_memo(1:p,1);
        % sensor_memo(1:p,8)  = sensor_memo(1:p,1);
        % sensor_memo(1:p,9)  = sensor_memo(1:p,1);
        % sensor_memo(1:p,10) = sensor_memo(1:p,1);
        % sensor_memo(1:p,11) = sensor_memo(1:p,1);
        % sensor_memo(1:p,12) = sensor_memo(1:p,1);
        % sensor_memo(1:p,13) = sensor_memo(1:p,1);
        % sensor_memo(1:p,14) = sensor_memo(1:p,1);

        filename = [workdir, '/sensors_p_', num2str(p), '.mat'];
        save(filename,'sensor_memo');

        % filename = [workdir, '/fND_p_', num2str(p), '.mat'];
        % save(filename,'fND');

        text = [ '---> ', num2str(p), ' sensor selection finished!' ];
        disp(text);
    end
    filename = [workdir, '/fND_NMG1_p_', num2str(p), '.mat'];
    save(filename,'fND');
%     filename = [workdir, '/fND_NMG2_p_', num2str(p), '.mat'];
%     save(filename,'fND2');
end

%% NOAA-SST =========================================================
if num_problem == 2

    %% Preprocces for NOAA-SST ======================================
    text='Readinng/Arranging a NOAA-SST dataset';
    disp(text);
    [Lat, Lon, time, mask, sst]...
    = F_pre_read_NOAA_SST( ['sst.wkmean.1990-present.nc'], ['lsmask.nc'] );
    [Uorg, Sorg, Vorg, Xorg, meansst, n] = F_pre_SVD_NOAA_SST(m, time, mask, sst);
    F_map_original(num_video, Xorg, meansst, mask, time, videodir);
    [U, Error_ave_pod, Error_std_pod]...
    = F_pre_truncatedSVD(r, Xorg, Uorg, Sorg, Vorg, num_video, meansst, mask, time, m, videodir);
    Error_ave_pod = repmat( Error_ave_pod , size(ps,2) );
    text='Complete Reading/Arranging a NOAA-SST dataset!';
    disp(text);

    %% Sensor selection =============================================
    for p = ps
        CNT = CNT+1;
        text = [ num2str(p),' sensor selection started --->' ];
        disp(text);

        %% Random selection -----------------------------------------
        % Average loop
        for w=1:1:num_ave
            [time_rand(CNT,w+1), H_rand, sensors_rand] = F_sensor_random(n,p);
            det_rand(CNT,w+1) = F_calc_det  (p,H_rand,U);
            tr_rand (CNT,w+1) = F_calc_trace(p,H_rand,U);
            eig_rand(CNT,w+1) = F_calc_eigen(p,H_rand,U);
            [Zestimate_rand, Error_rand(CNT,w+1), Error_std_rand(CNT,w+1)] ...
            = F_calc_error(m, Xorg, U, H_rand);
        end
        % Averaging
        [ time_rand, det_rand, tr_rand, eig_rand, Error_rand, Error_std_rand ]...
        = F_data_ave2( CNT, num_ave, time_rand, det_rand, tr_rand, eig_rand, Error_rand, Error_std_rand );

        %% D-optimality - Convex-------------------------------------
        %!! This is very time consuming proceduce, We do not recommend to try this
        % [time_DC(CNT,1), H_DC, sensors_DC, ...
        %  NT_TOL_cal_DC(CNT,1), iter_DC(CNT,1)] ...
        %  = F_sensor_DC(U,p,maxiteration);
        % det_DC(CNT,1) = F_calc_det(p,H_DC,U);
        % tr_DC(CNT,1)  = F_calc_trace(p,H_DC,U);
        % eig_DC(CNT,1) = F_calc_eigen(p,H_DC,U);
        %!! I recommend you use the following dummy values 
        %   if you do not need the solution in the convex approximation in NOAA-SST.
        time_DC(CNT,1) = time_rand(CNT,1);
        det_DC (CNT,1) = det_rand (CNT,1);
        tr_DC  (CNT,1) = tr_rand  (CNT,1);
        eig_DC (CNT,1) = eig_rand (CNT,1);
        H_DC=H_rand;
        sensors_DC=sensors_rand;
        NT_TOL_cal_DC(CNT,w+1)=0;
        iter_DC(CNT,w+1)=0;
        %!!
        [Zestimate_DC, Error_DC(CNT,1), Error_std_DC(CNT,1)] ...
        = F_calc_error(m, Xorg, U, H_DC);
        NT_TOL_cal_DC(CNT,1)=mean(NT_TOL_cal_DC(CNT,2:w+1));
        iter_DC(CNT,1)=mean(iter_DC(CNT,2:w+1));
        
        % %% Maximization of row norm - Greedy based on QR ------------
        % [time_QR(CNT,1), H_QR, sensors_QR] = F_sensor_QR(U,p);
        % det_QR (CNT,1) = F_calc_det  (p,H_QR,U);
        % tr_QR  (CNT,1) = F_calc_trace(p,H_QR,U);
        % eig_QR (CNT,1) = F_calc_eigen(p,H_QR,U);
        % [Zestimate_QR, Error_QR(CNT,1), Error_std_QR(CNT,1)] ...
        % = F_calc_error(m, Xorg, U, H_QR);

        % %% D-optimality - Greedy ------------------------------------
        % [time_DG(CNT,1), H_DG, sensors_DG] = F_sensor_DG(U,p);
        % det_DG (CNT,1) = F_calc_det  (p,H_DG,U);
        % tr_DG  (CNT,1) = F_calc_trace(p,H_DG,U);
        % eig_DG (CNT,1) = F_calc_eigen(p,H_DG,U);
        % [Zestimate_DG, Error_DG(CNT,1), Error_std_DG(CNT,1)] ...
        % = F_calc_error(m, Xorg, U, H_DG);

        %% D-optimality - Hybrid of QR and DG -----------------------
        [time_QD(CNT,1), H_QD, sensors_QD] = F_sensor_QD(U,p);
        det_QD (CNT,1) = F_calc_det  (p,H_QD,U);
        tr_QD  (CNT,1) = F_calc_trace(p,H_QD,U);
        eig_QD (CNT,1) = F_calc_eigen(p,H_QD,U);
        [Zestimate_QD, Error_QD(CNT,1), Error_std_QD(CNT,1)] ...
        = F_calc_error(m, Xorg, U, H_QD);

        %% A-optimality -  Greedy -----------------------------------
        [time_AG(CNT,1), H_AG, sensors_AG] = F_sensor_AG(U,p);
        det_AG (CNT,1) = F_calc_det  (p,H_AG,U);
        tr_AG  (CNT,1) = F_calc_trace(p,H_AG,U);
        eig_AG (CNT,1) = F_calc_eigen(p,H_AG,U);
        [Zestimate_AG, Error_AG(CNT,1), Error_std_AG(CNT,1)] ...
        = F_calc_error(m, Xorg, U, H_AG);

        %% E-optimality -  Greedy -----------------------------------
        [time_EG(CNT,1), H_EG, sensors_EG] = F_sensor_EG(U,p);
        det_EG (CNT,1) = F_calc_det  (p,H_EG,U);
        tr_EG  (CNT,1) = F_calc_trace(p,H_EG,U);
        eig_EG (CNT,1) = F_calc_eigen(p,H_EG,U);
        [Zestimate_EG, Error_EG(CNT,1), Error_std_EG(CNT,1)] ...
        = F_calc_error(m, Xorg, U, H_EG);

        %% Nondominated-solution-based multiobjective Greedy --------
        [time_NMG(CNT,1), sensors_NMG, fND] = F_sensor_NMG(U,p,Lmax,Rmax);
        %det_NMG (CNT,1) = F_calc_det  (p,H_NMG,U);
        %tr_NMG  (CNT,1) = F_calc_trace(p,H_NMG,U);
        %eig_NMG (CNT,1) = F_calc_eigen(p,H_NMG,U);
        % det_NMG  (CNT,1) = - min(fND(:,p+1));
        % tr_NMG   (CNT,1) =   min(fND(:,p+2));
        % eig_NMG  (CNT,1) = - min(fND(:,p+3));
        [det_NMG(CNT,1), Ldet] = min(fND(:,p+1));
        [tr_NMG(CNT,1),  Ltr ] = min(fND(:,p+2));
        [eig_NMG(CNT,1), Leig] = min(fND(:,p+3));
        det_NMG = -det_NMG;
        eig_NMG = -eig_NMG;
        H_NMG_det = F_calc_sensormatrix(p, n, sensors_NMG(Ldet,:));
        H_NMG_tr  = F_calc_sensormatrix(p, n, sensors_NMG(Ltr ,:));
        H_NMG_eig = F_calc_sensormatrix(p, n, sensors_NMG(Leig,:));
        [Zestimate_NMG_det, Error_NMG_det(CNT,1), Error_std_NMG_det(CNT,1)] ...
        = F_calc_error(m, Xorg, U, H_NMG_det);
        [Zestimate_NMG_tr, Error_NMG_tr(CNT,1), Error_std_NMG_tr(CNT,1)] ...
        = F_calc_error(m, Xorg, U, H_NMG_tr);
        [Zestimate_NMG_eig, Error_NMG_eig(CNT,1), Error_std_NMG_eig(CNT,1)] ...
        = F_calc_error(m, Xorg, U, H_NMG_eig);

        %% Sensor location ==========================================
        sensor_memo = zeros(p,8);
        sensor_memo(1:p,1) = sensors_rand(1:p)';
        sensor_memo(1:p,3) = sensors_QD(1:p)';
        sensor_memo(1:p,4) = sensors_AG(1:p)';
        sensor_memo(1:p,5) = sensors_EG(1:p); %remove ' 2021/3/12
        sensor_memo(1:p,6) = sensors_NMG(Ldet,1:p)';
        sensor_memo(1:p,7) = sensors_NMG(Ltr, 1:p)';
        sensor_memo(1:p,8) = sensors_NMG(Leig,1:p)';
        sensor_memo(1:p,6)  = sensors_GDG(1:p);
        sensor_memo(1:p,7)  = sensors_RGDG(1:p);
        sensor_memo(1:p,8)  = sensors_ERGDG(1:p);
        sensor_memo(1:p,10) = sensors_GEG(1:p);
        sensor_memo(1:p,11) = sensors_RGEG(1:p);
        sensor_memo(1:p,12) = sensors_ERGEG(1:p);
        sensor_memo(1:p,10) = sensors_GAG(1:p);
        filename = [workdir, '/sensors_p_', num2str(p), '.mat'];
        save(filename,'sensor_memo');

        %% Video ====================================================
        name='rand';
        F_map_reconst(r, num_video, Xorg, meansst, U, mask, time, p, ...
                        sensors_rand, Zestimate_rand, name, videodir, sensordir)
        name='QD';
        F_map_reconst(r, num_video, Xorg, meansst, U, mask, time, p, ...
                        sensors_QD, Zestimate_QD, name, videodir, sensordir)
        name='AG';
        F_map_reconst(r, num_video, Xorg, meansst, U, mask, time, p, ...
                        sensors_AG, Zestimate_AG, name, videodir, sensordir)
        name='EG';
        F_map_reconst(r, num_video, Xorg, meansst, U, mask, time, p, ...
                        sensors_EG, Zestimate_EG, name, videodir, sensordir)
        name='NMG_det';
        F_map_reconst(r, num_video, Xorg, meansst, U, mask, time, p, ...
                        sensors_NMG(Ldet,1:p), Zestimate_NMG_det, name, videodir, sensordir)
        name='NMG_tr';
        F_map_reconst(r, num_video, Xorg, meansst, U, mask, time, p, ...
                        sensors_NMG(Ltr ,1:p), Zestimate_NMG_tr, name, videodir, sensordir)
        name='NMG_eig';
        F_map_reconst(r, num_video, Xorg, meansst, U, mask, time, p, ...
                        sensors_NMG(Leig,1:p), Zestimate_NMG_eig, name, videodir, sensordir)
        
        text = [ '---> ', num2str(p), ' sensor selection finished!' ];
        disp(text);
    end
end

%% Data organization ================================================
% Arrange
[time_all] = F_data_arrange1( ps, CNT,    time_rand, time_QD,...
                              time_AG,    time_EG,   time_NMG,...
                              time_NMG2, ...
                              time_GDG,  time_RGDG, time_ERGDG,...
                              time_GEG,  time_RGEG, time_ERGEG,...
                              time_GAG );
[det_all]  = F_data_arrange1( ps, CNT, det_rand, det_QD,...
                              det_AG,  det_EG,   det_NMG,...
                              det_NMG2, ...
                              det_GDG, det_RGDG, det_ERGDG,...
                              det_GEG, det_RGEG, det_ERGEG,...
                              det_GAG );
[tr_all]   = F_data_arrange1( ps, CNT, tr_rand, tr_QD,...
                              tr_AG,   tr_EG,   tr_NMG,...
                              tr_NMG2, ...
                              tr_GDG,  tr_RGDG, tr_ERGDG,...
                              tr_GEG,  tr_RGEG, tr_ERGEG,...
                              tr_GAG );
[eig_all]  = F_data_arrange1( ps, CNT, eig_rand, eig_QD,...
                              eig_AG,  eig_EG,   eig_NMG,...
                              eig_NMG2, ...
                              eig_GDG, eig_RGDG, eig_ERGDG,...
                              eig_GEG, eig_RGEG, eig_ERGEG,...
                              eig_GAG);
if num_problem == 2
    [Error] = F_data_arrange2( ps,         CNT, ...
                               Error_rand, Error_std_rand, ...
                               Error_DC,   Error_std_DC,   ...
                               Error_QD,   Error_std_QD,   ...
                               Error_AG,   Error_std_AG,   ...
                               Error_EG,   Error_std_EG,   ...
                               Error_NMG_det, Error_std_NMG_det, ...
                               Error_NMG_tr,  Error_std_NMG_tr,  ...
                               Error_NMG_eig, Error_std_NMG_eig, ...
                               Error_ave_pod );
end
% [log_DC] = F_data_arrange3( ps, CNT, NT_TOL_cal_DC, iter_DC );

% Normalize
[Normalized_det] = F_data_normalize( ps, CNT, det_rand, det_QD, ...
                                     det_AG,  det_EG,   det_NMG,...
                                     det_NMG2, ...
                                     det_GDG, det_RGDG, det_ERGDG,...
                                     det_GEG, det_RGEG, det_ERGEG,...
                                     det_GAG, det_QD );
[Normalized_det2]= F_data_normalize( ps, CNT, det_rand, det_QD, ...
                                     det_AG,  det_EG,   det_NMG,...
                                     det_NMG2, ...
                                     det_GDG, det_RGDG, det_ERGDG,...
                                     det_GEG, det_RGEG, det_ERGEG,...
                                     det_GAG, det_AG );
[Normalized_det3]= F_data_normalize( ps, CNT, det_rand, det_QD, ...
                                     det_AG,  det_EG,   det_NMG,...
                                     det_NMG2, ...
                                     det_GDG, det_RGDG, det_ERGDG,...
                                     det_GEG, det_RGEG, det_ERGEG,...
                                     det_GAG, det_EG );
[Normalized_tr]  = F_data_normalize( ps, CNT, tr_rand,  tr_QD, ...
                                     tr_AG,   tr_EG,    tr_NMG,...
                                     tr_NMG2, ...
                                     tr_GDG,  tr_RGDG, tr_ERGDG,...
                                     tr_GEG,  tr_RGEG, tr_ERGEG,...
                                     tr_GAG,  tr_QD );
[Normalized_tr2] = F_data_normalize( ps, CNT, tr_rand,  tr_QD, ...
                                     tr_AG,   tr_EG,    tr_NMG,...
                                     tr_NMG2, ...
                                     tr_GDG,  tr_RGDG, tr_ERGDG,...
                                     tr_GEG,  tr_RGEG, tr_ERGEG,...
                                     tr_GAG,  tr_AG );
[Normalized_tr3] = F_data_normalize( ps, CNT, tr_rand,  tr_QD, ...
                                     tr_AG,   tr_EG,    tr_NMG,...
                                     tr_NMG2, ...
                                     tr_GDG,  tr_RGDG, tr_ERGDG,...
                                     tr_GEG,  tr_RGEG, tr_ERGEG,...
                                     tr_GAG,  tr_EG );
[Normalized_eig] = F_data_normalize( ps, CNT, eig_rand, eig_QD, ...
                                     eig_AG,  eig_EG,   eig_NMG,...
                                     eig_NMG2,...
                                     eig_GDG, eig_RGDG, eig_ERGDG,...
                                     eig_GEG, eig_RGEG, eig_ERGEG,...
                                     eig_GAG, eig_QD );
[Normalized_eig2] = F_data_normalize( ps, CNT, eig_rand, eig_QD, ...
                                     eig_AG,  eig_EG,   eig_NMG,...
                                     eig_NMG2,...
                                     eig_GDG, eig_RGDG, eig_ERGDG,...
                                     eig_GEG, eig_RGEG, eig_ERGEG,...
                                     eig_GAG, eig_AG );
[Normalized_eig3]= F_data_normalize( ps, CNT, eig_rand, eig_QD, ...
                                     eig_AG,  eig_EG,   eig_NMG,...
                                     eig_NMG2,...
                                     eig_GDG, eig_RGDG, eig_ERGDG,...
                                     eig_GEG, eig_RGEG, eig_ERGEG,...
                                     eig_GAG, eig_EG );

%% Save =============================================================
cd(workdir)
save('time.mat','time_all');
save('det.mat','det_all');
save('trace.mat','tr_all');
save('eigen.mat','eig_all');
save('Normalized_det_basedQD.mat','Normalized_det');
save('Normalized_det_basedAG.mat','Normalized_det2');
save('Normalized_det_basedEG.mat','Normalized_det3');
save('Normalized_trace_basedQD.mat','Normalized_tr');
save('Normalized_trace_basedAG.mat','Normalized_tr2');
save('Normalized_trace_basedEG.mat','Normalized_tr3');
save('Normalized_eigen_basedQD.mat','Normalized_eig');
save('Normalized_eigen_basedAG.mat','Normalized_eig2');
save('Normalized_eigen_basedEG.mat','Normalized_eig3');
save('time_rand.mat','time_rand');
save('det_rand.mat','det_rand');
save('trace_rand.mat','tr_rand');
save('eigen_rand.mat','eig_rand');
if num_problem == 1
    save('time_QD.mat',    'time_QD');
    save('time_AG.mat',    'time_AG');
    save('time_EG.mat',    'time_EG');
    save('time_NMG.mat',   'time_NMG');
    save('time_NMG2.mat',  'time_NMG2');
    save('time_NMG_separate.mat','time_NMG_separate');
%     save('time_NMG2_separate.mat','time_NMG2_separate');
    save('time_GDG.mat',   'time_GDG');
    save('time_RGDG.mat',  'time_RGDG');
    save('time_ERGDG.mat', 'time_ERGDG');
    save('time_GEG.mat',   'time_GEG');
    save('time_EGEG.mat',  'time_RGEG');
    save('time_ERGEG.mat', 'time_ERGEG');
    save('time_GAG.mat',   'time_GAG');
    save('det_QD.mat',    'det_QD');
    save('det_AG.mat',    'det_AG');
    save('det_EG.mat',    'det_EG');
    save('det_NMG.mat',   'det_NMG');
    save('det_NMG2.mat',  'det_NMG2');
    save('det_GDG.mat',   'det_GDG');
    save('det_RGDG.mat',  'det_RGDG');
    save('det_ERGDG.mat', 'det_ERGDG');
    save('det_GEG.mat',   'det_GEG');
    save('det_RGEG.mat',  'det_RGEG');
    save('det_ERGEG.mat', 'det_ERGEG');
    save('det_GAG.mat',   'det_GAG');
    save('tr_QD.mat',    'tr_QD');
    save('tr_AG.mat',    'tr_AG');
    save('tr_EG.mat',    'tr_EG');
    save('tr_NMG.mat',   'tr_NMG');
    save('tr_NMG2.mat',  'tr_NMG2');
    save('tr_GDG.mat',   'tr_GDG');
    save('tr_RGDG.mat',  'tr_RGDG');
    save('tr_ERGDG.mat', 'tr_ERGDG');
    save('tr_GEG.mat',   'tr_GEG');
    save('tr_RGEG.mat',  'tr_RGEG');
    save('tr_ERGEG.mat', 'tr_ERGEG');
    save('tr_GAG.mat',   'tr_GAG');
    save('eig_QD.mat',   'eig_QD');
    save('eig_AG.mat',   'eig_AG');
    save('eig_EG.mat',   'eig_EG');
    save('eig_NMG.mat',  'eig_NMG');
    save('eig_NMG2.mat', 'eig_NMG2');
    save('eig_GDG.mat',  'eig_GDG');
    save('eig_RGDG.mat', 'eig_RGDG');
    save('eig_ERGDG.mat','eig_ERGDG');
    save('eig_GEG.mat',  'eig_GEG');
    save('eig_RGEG.mat', 'eig_RGEG');
    save('eig_ERGEG.mat','eig_ERGEG');
    save('eig_GAG.mat',  'eig_GAG');
end
if num_problem == 2
    save('Error.mat','Error');
    save('Error_rand.mat','Error_rand');
end
% save('log_DC.mat','log_DC');

warning('on','all')
disp('Congratulations!');
cd ../src
%% ///////////////////////////////////////////////////////////////////
>>>>>>> 6150b0a6442ac2200723bae0ca9384e6c5610ed9
%% Main program end