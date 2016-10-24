MODULE Clad_Cylinder
    
    TASK PERS seamdata seam_clad_cylinder:=[0.2,0.05,[0,0,0,0,0,0,0,0,0],0,0,0,0,0,[0,0,0,0,0,0,0,0,0],0,0,[0,0,0,0,0,0,0,0,0],0.1,0,[0,0,0,0,0,0,0,0,0],0.05];
    TASK PERS welddata weld_clad_cylinder:=[2.96333,2.96333,[6,0,25,0,0,240,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS weavedata weave_clad_cylinder:=[1,0,6,22,0,0,0,0,0,0,0,0,22,0,0];
    TASK PERS trackdata track_clad_cylinder:=[0,FALSE,100,[0,10,10,2,0,3,10,3,10],[0,0,0,0,0,0,0]];
    
    PERS robtarget temp:=[[666.172,659.152,-396.543],[0.0166791,-0.95689,0.0307167,0.288337],[0,-1,-1,1],[9E+09,90,352,9E+09,9E+09,9E+09]];
    PERS robtarget service_1:=[[270.34,913.75,1460.6],[0.0442608,-0.677787,-0.732987,0.0370681],[0,-2,0,1],[9E+09,135,352,9E+09,9E+09,9E+09]];
    PERS robtarget service_1a:=[[-278.1,227.48,-159],[0.353263,0.0170014,-0.935157,0.0199643],[-1,0,-1,0],[9E+09,89.9985,438.073,9E+09,9E+09,9E+09]];
    PERS robtarget service_2:=[[376.25,919.96,1444.06],[0.0238569,0.688859,0.724358,0.0143966],[0,-2,0,1],[9E+09,179,352,9E+09,9E+09,9E+09]];
    PERS robtarget service_2a:=[[-46.87,252.19,-159.41],[0.288141,0.026723,-0.957212,0.00238382],[-1,0,-1,0],[9E+09,89.9992,-8.30485E-05,9E+09,9E+09,9E+09]];
    PERS robtarget lineweld_1:=[[624.29,640.26,-470.3],[0.0243372,-0.966498,0.0325428,0.253433],[0,-1,0,1],[9E+09,90,363,9E+09,9E+09,9E+09]];
    PERS robtarget lineweld_2:=[[-108.43,640.27,-460.63],[0.024344,-0.966493,0.0325309,0.253454],[0,-1,0,1],[9E+09,90,352,9E+09,9E+09,9E+09]];
    PERS robtarget lineweld_mid_a:=[[598.89,640.26,-470.3],[0.0243372,-0.966498,0.0325428,0.253433],[0,-1,0,1],[9E+09,90,352,9E+09,9E+09,9E+09]];
    PERS robtarget lineweld_mid_b:=[[624.29,640.26,-470.3],[0.0243372,-0.966498,0.0325428,0.253433],[0,-1,0,1],[9E+09,90,352,9E+09,9E+09,9E+09]];
    PERS robtarget lineweld_mid_c:=[[-83.03,640.27,-460.63],[0.024344,-0.966493,0.0325309,0.253454],[0,-1,0,1],[9E+09,90,352,9E+09,9E+09,9E+09]];
    PERS robtarget lineweld_3:=[[-21.9622,-3.73471,47.089],[0.00814749,-0.992916,0.0984212,0.0660663],[0,-1,0,0],[9E+09,90,-182.775,9E+09,9E+09,9E+09]];
    PERS robtarget lineweld_1a:=[[2027.93,2087.62,580.13],[0.00198321,-0.0359875,-0.998853,-0.0315434],[-1,-1,0,1],[9E+09,-0.205903,-125.729,9E+09,9E+09,9E+09]];
    PERS robtarget lineweld_2a:=[[1973.74,2087.63,580.14],[0.00198529,-0.0359863,-0.998853,-0.0315428],[-1,-1,0,1],[9E+09,-0.205903,-125.729,9E+09,9E+09,9E+09]];
    PERS robtarget lineweld_mid:=[[630,-8.43,144],[0.997726,0.0368744,0.0547652,0.0135515],[-1,-2,1,1],[9E+09,0,134.6,9E+09,9E+09,9E+09]];
    PERS robtarget Safe_pos:=[[806.5,643.79,-382.18],[0.0243097,-0.966473,0.0325661,0.25353],[0,-1,-1,1],[9E+09,90,352,9E+09,9E+09,9E+09]];
    
    PERS num beadangle;
    PERS num beadwidth:=22;     !This sets the distance between beads for the flat production plate 
    pers num retractionspeed;
    PERS num Fronius_JOB;
    PERS num pass:=1;
    var clock myclock;
    var clock flangeclock;
    pers num i:=33;
    PERS num maxi;
    VAR num maxi1:=0;
    VAR speeddata v_7000:= [7000,500,5000,40];
    
    
     PROC Cylinder_clad_greeting()
        i:=0;
        pass := 5;
        TPReadFK reg1,"What size flange is being cladded?","10","12","16",stEmpty,"Diameter Not Listed";
        IF reg1=1 THEN
            beadangle := 11; !Measured in deg
            maxi:=33;
        ELSEIF reg1=2 THEN
            beadangle := 9; !Measured in deg
            maxi:=40;
        ELSEIF reg1=3 THEN
            beadangle := 6.9; !Measured in deg
            maxi:=52;
        ELSE
            TPWrite "This program can only clad 12 and 16 in flanges";
            WaitTime 5;
            Cylinder_clad_greeting;
        ENDIF
        
        TPReadFK reg2, "Which layer are you doing?", "First layers Stainless","First layer CCO","Second Layer CCO",stEmpty,"Other";
        IF reg2=1 THEN
            retractionspeed:=   7 / 2.362204; !Measured in IN/min
            Fronius_JOB:=       6; !Must be whole number
        ELSEIF reg2=2 THEN
            retractionspeed:=   7 / 2.362204; !Measured in IN/min
            Fronius_JOB:=       7; !Must be whole number
        ELSEIF reg2=3 THEN
            retractionspeed:=   7 / 2.362204; !Measured in IN/min
            Fronius_JOB:=       7; !Must be whole number
         ELSE
            TPWrite "This program is only meant to do those three types of beads!";
            WaitTime 5;
            Cylinder_clad_greeting;
        ENDIF

        temp:=CRobT(\Tool:=tCMTlong\WObj:=wobj2);
        lineweld_1.extax.eax_c:=temp.extax.eax_c;
        CLKreset flangeclock;
        ClkStart flangeclock;    
        WHILE i<=maxi-1 DO
            i:=i+1;
            Cylinder_clad;
        ENDWHILE
        ClkStop flangeclock;
        reg1:=ClkRead(flangeclock);
        TPWrite "Total cladding time is (mins)" \Num:=reg1/60;
        Stop;
    ENDPROC
    
    PROC Cylinder_clad_setup()
        
        beadwidth:=        22; !Measured in mm 
        
        weld_clad_cylinder.main_arc.sched:= Fronius_JOB;
        weld_clad_cylinder.weld_speed:=retractionspeed;
        weld_clad_cylinder.org_weld_speed:=retractionspeed;
        weave_clad_cylinder.weave_width:=beadwidth;
        weave_clad_cylinder.org_weave_width:=beadwidth;

        Safe_pos.extax.eax_b:=90;
        lineweld_1.extax.eax_b:=Safe_pos.extax.eax_b;
        lineweld_2.extax.eax_b:=Safe_pos.extax.eax_b;
        lineweld_mid_a.extax.eax_b:=Safe_pos.extax.eax_b;
        lineweld_mid_b.extax.eax_b:=Safe_pos.extax.eax_b;
        lineweld_mid_c.extax.eax_b:=Safe_pos.extax.eax_b;
        
        !lineweld_1.extax.eax_c:=-180;
        lineweld_2.extax.eax_c:=lineweld_1.extax.eax_c;
        lineweld_mid_a.extax.eax_c:=lineweld_1.extax.eax_c;
        lineweld_mid_b.extax.eax_c:=lineweld_1.extax.eax_c;
        lineweld_mid_c.extax.eax_c:=lineweld_1.extax.eax_c;
        Safe_pos.extax.eax_c:=lineweld_1.extax.eax_c;
       
    ENDPROC
    
    PROC Cylinder_clad_cleanup()
        
        lineweld_1.extax.eax_c:=lineweld_1.extax.eax_c+beadangle;
        
        IF lineweld_1.extax.eax_c>= 720 THEN
            lineweld_1.extax.eax_c:=Safe_pos.extax.eax_c-1800+beadangle;
        endif
            
    ENDPROC
    
    PROC Cylinder_touch()
        ServiceTip;
        MoveL Safe_pos, v_7000, fine, tCMTshort\WObj:=wobj2;
        MoveL Offs(lineweld_1,0,0,9), v_7000, z5, tCMTshort\WObj:=wobj2;
        lineweld_mid_a:=lineweld_1;
        lineweld_mid_b:=lineweld_1;
        lineweld_mid_c:=lineweld_2;
        lineweld_mid_a.trans.x:=lineweld_mid_a.trans.x-25.4;
        lineweld_mid_c.trans.x:=lineweld_mid_c.trans.x+25.4;
        MoveL lineweld_1,v_7000,z0,tCMTshort\WObj:=wobj2;
       ! Stop;
        MoveL lineweld_2,v_7000,z0,tCMTshort\WObj:=wobj2;
       ! Stop;
        !Search_1D pose1\SearchStop:=lineweld_2, Offs(lineweld_2,0,0,6), lineweld_2, v200, tCMTshort\WObj:=wobj2\SchSpeed:=40;
        !Search_1D pose1\SearchStop:=lineweld_1, Offs(lineweld_1,0,0,7), lineweld_1, v200, tCMTshort\WObj:=wobj2\SchSpeed:=40;
        !lineweld_2.trans.x:=lineweld_3.trans.x-2.2;
        !lineweld_3.trans.z:=lineweld_2.trans.z-3;
    ENDPROC
    
    PROC Cylinder_clad()
        ConfJ\Off;
        ConfL\Off;
        Cylinder_clad_setup;
        MoveJ Safe_pos, v_7000, fine, tCMTshort\WObj:=wobj2;
        RecoveryPosSet;
        MoveL Safe_pos, v_7000, fine, tCMTshort\WObj:=wobj2;
        IF pass>3 THEN         Cylinder_touch;         pass:=0;             ENDIF
        pass:=pass+1;
        MoveL Offs(lineweld_1,0,-16,5), v_7000, fine, tCMTshort\WObj:=wobj2;                        !Get into approach position                       !Get into approach position                        !Get into approach position                       !Get into approach position
        !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        ArcLStart offs(lineweld_1,0,-16,0), v_7000, seam_clad_cylinder, weld_clad_cylinder, fine, tCMTshort\WObj:=wobj2\Track:=track_clad_cylinder;
        ArcL offs(lineweld_1,0,14,0), v_7000, seam_clad_cylinder, weld_clad_cylinder, z0, tCMTshort\WObj:=wobj2\Track:=track_clad_cylinder\Time:=2;
        ArcL lineweld_1, v_7000, seam_clad_cylinder, weld_clad_cylinder, z0, tCMTshort\WObj:=wobj2\Track:=track_clad_cylinder\Time:=0.5;        !Start Welding
        !ArcL lineweld_mid_a, v500, seam_clad_cylinder, weld_clad_cylinder\Weave:=weave_clad_cylinder, z1, tCMTshort\WObj:=wobj2;           !Weld  the bead, move to final position
        !ArcL lineweld_mid_b, v500, seam_clad_cylinder, weld_clad_cylinder\Weave:=weave_clad_cylinder, z1, tCMTshort\WObj:=wobj2;           !Weld  the bead, move to final position
        !ArcL lineweld_mid_c, v500, seam_clad_cylinder, weld_clad_cylinder\Weave:=weave_clad_cylinder, z1, tCMTshort\WObj:=wobj2;           !Weld  the bead, move to final position
        ArcL lineweld_2, v_7000, seam_clad_cylinder, weld_clad_cylinder\Weave:=weave_clad_cylinder, fine, tCMTshort\WObj:=wobj2\Track:=track_clad_cylinder;           !Weld  the bead, move to final position
        WaitTime 0.25; 
        ArcL offs(lineweld_2,0,14,0), v_7000, seam_clad_cylinder, weld_clad_cylinder, fine, tCMTshort\WObj:=wobj2\Track:=track_clad_cylinder\Time:=0.125;          !Weld  the bead, move to final position
        WaitTime 0.25;
        ArcL offs(lineweld_2,0,-14,0), v4000, seam_clad_cylinder, weld_clad_cylinder, fine, tCMTshort\WObj:=wobj2\Track:=track_clad_cylinder\Time:=0.5;
        WaitTime 0.125;
        ArcLEnd offs(lineweld_2,0,-16,0), v4000, seam_clad_cylinder, weld_clad_cylinder, z0, tCMTshort\WObj:=wobj2\Track:=track_clad_cylinder;
        !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        MoveL offs(lineweld_2,0,0,5), v_7000, fine, tCMTshort\WObj:=wobj2;                        !Move to exit position
        MoveL Offs(lineweld_1,0,0,5), v_7000, z5, tCMTshort\WObj:=wobj2;
        MoveL Safe_pos, v_7000, fine, tCMTshort\WObj:=wobj2;
        RecoveryPosReset;
        Feedback;
        Cylinder_clad_cleanup;
    ENDPROC
    
    PROC Feedback()
        ClkStop myclock;
        reg1:=ClkRead(myclock);
        reg2:=lineweld_2.trans.x-lineweld_1.trans.x;
        IF reg1<=0 THEN
            reg1:=1;
        ENDIF
        reg3:=3600*(reg2/25.4)*(weave_clad_cylinder.weave_width/25.4)/reg1;
        TPErase;
        TPWrite "Bead time (s)" \Num:=reg1;
        TPWrite "Bead length (mm) " \Num:=reg2;
        TPWrite "Cladding Speed (sqin/hr) " \Num:=reg3;
        TPWrite "Pass number " \Num:=i;
        TPWrite "Out of max passes " \Num:=maxi;
        TPWrite "Every 4th pass go for service " \Num:=pass;
        reg1:=ClkRead(flangeclock);
        TPWrite "Elapsed time (min)" \Num:=reg1/60;
        CLKreset myclock;
        ClkStart myclock;    
    ENDPROC
    
    PROC ServiceTip()
        temp:=CRobT(\Tool:=tCMTlong\WObj:=wobj2);                          !Remember current position
        service_1.extax:=temp.extax;
        service_2.extax:=temp.extax;
        service_2.extax.eax_b:=179;
        service_1.extax.eax_b :=135;
        MoveL offs(service_1,60,0,100), v_7000, fine, tCMTshort\WObj:=wService;   !Move to Service_1a approach position
        MoveL offs(service_1,60,0,0), v_7000, fine, tCMTshort\WObj:=wService;     !Move to Service_1a position to cut  wire
        SetDO doFr1FeedForward,1;                                               !Feed wire
        !WaitTime 1;                                                             !Allow wire to feed
        SetDO doFr1FeedForward,0;                                               !Stop Wire feed
        MoveL service_1, v4000, fine, tCMTshort\WObj:=wService;                  !Move over to begin shear
        MoveL offs(service_1,60,0,0), v_7000, fine, tCMTshort\WObj:=wService;     !Move out to stop shear
        MoveL offs(service_1,60,0,100), v_7000, fine, tCMTshort\WObj:=wService;   !Move to service_1a approach position   
        MoveL offs(service_2,0,0,100), v_7000, fine, tCMTshort\WObj:=wService;    !Move to Service_2a approach postion
        MoveL service_2, v_7000, fine, tCMTshort\WObj:=wService;                  !Move to Tip cleaning position
        SetDO doReamerStart,1;                                                  !Start Tip cleaning
        !WaitTime 2;                                                             !Allow time for tip cleaning
        SetDO doReamerStart,0;
        !WaitTime .5;                                                            !Stop tip cleaning
        MoveL offs(service_2,0,0,100), v4000, fine, tCMTshort\WObj:=wService;    !Move to Service_2 approach position
        MoveL offs(service_1,60,0,100), v4000, fine, tCMTshort\WObj:=wService;   !Move to Service_1a approach position
        MoveL offs(service_1,60,0,0), v4000, fine, tCMTshort\WObj:=wService;     !Move to Service_1a position to cut  wire
        SetDO doFr1FeedForward,1;                                               !Feed wire
        !WaitTime 1;                                                             !Allow wire to feed
        SetDO doFr1FeedForward,0;                                               !Stop Wire feed
        MoveL service_1, v100, fine, tCMTshort\WObj:=wService;                  !Move over to begin shear
        MoveL offs(service_1,60,0,0), v4000, fine, tCMTshort\WObj:=wService;     !Move out to stop shear
        MoveL offs(service_1,60,0,100), v4000, fine, tCMTshort\WObj:=wService;   !Move to service_1a approach position   
        ! MoveL temp, v500, fine, tCMTlong\WObj:=wobj2;                         !Move back to position from before SERVICETIP was called
    ENDPROC
	
    TRAP Trap_servicetip
         temp:=CRobT(\Tool:=tCMTlong\WObj:=wobj2);                          !Remember current position
        service_1.extax:=temp.extax;
        service_2.extax:=temp.extax;
        service_2.extax.eax_b:=179;
        service_1.extax.eax_b :=135;
        MoveL offs(service_1,60,0,100), v4000, fine, tCMTshort\WObj:=wService;   !Move to Service_1a approach position
        MoveL offs(service_1,60,0,0), v4000, fine, tCMTshort\WObj:=wService;     !Move to Service_1a position to cut  wire
        SetDO doFr1FeedForward,1;                                               !Feed wire
        !WaitTime 1;                                                             !Allow wire to feed
        SetDO doFr1FeedForward,0;                                               !Stop Wire feed
        MoveL service_1, v4000, fine, tCMTshort\WObj:=wService;                  !Move over to begin shear
        MoveL offs(service_1,60,0,0), v4000, fine, tCMTshort\WObj:=wService;     !Move out to stop shear
        MoveL offs(service_1,60,0,100), v4000, fine, tCMTshort\WObj:=wService;   !Move to service_1a approach position   
        MoveL offs(service_2,0,0,100), v4000, fine, tCMTshort\WObj:=wService;    !Move to Service_2a approach postion
        MoveL service_2, v4000, fine, tCMTshort\WObj:=wService;                  !Move to Tip cleaning position
        SetDO doReamerStart,1;                                                  !Start Tip cleaning
        !WaitTime 2;                                                             !Allow time for tip cleaning
        SetDO doReamerStart,0;
        !WaitTime .5;                                                            !Stop tip cleaning
        MoveL offs(service_2,0,0,100), v500, fine, tCMTshort\WObj:=wService;    !Move to Service_2 approach position
        MoveL offs(service_1,60,0,100), v100, fine, tCMTshort\WObj:=wService;   !Move to Service_1a approach position
        MoveL offs(service_1,60,0,0), v500, fine, tCMTshort\WObj:=wService;     !Move to Service_1a position to cut  wire
        SetDO doFr1FeedForward,1;                                               !Feed wire
       ! WaitTime 1;                                                             !Allow wire to feed
        SetDO doFr1FeedForward,0;                                               !Stop Wire feed
        MoveL service_1, v100, fine, tCMTshort\WObj:=wService;                  !Move over to begin shear
        MoveL offs(service_1,60,0,0), v500, fine, tCMTshort\WObj:=wService;     !Move out to stop shear
        MoveL offs(service_1,60,0,100), v500, fine, tCMTshort\WObj:=wService;   !Move to service_1a approach position   
        ! MoveL temp, v500, fine, tCMTlong\WObj:=wobj2;   
    ENDTRAP


ENDMODULE
