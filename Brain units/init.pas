unit Init;

interface
const mMax=16; mMaxExp=100000; MaxSmpls=19; MaxPh=500;
type
    longvect=array[0..2*mMax] of double;
    vect    =array[0..mMax]   of double;
    matr    =array[1..mMax,1..mMax] of double;
    vectint =array[1..2*mMax] of integer;
    vecstr  =array[1..2*mMax] of string;
    vect2   =array[1..2]      of double;
var
    Vexp              :array[0..mMaxExp,0..MaxSmpls] of double;
    Vmod              :array[0..mMaxExp] of double;
    g,g_dg,LimL,LimR  :longvect;
    ifC,iC_ig,ig_iC   :vectint;
    strC              :vecstr;
    mC,m              :integer;
    V,VatE,VatI,p,po,pn, Q,dQdt,Vrest,gL,VL,
    uu,ss,DuDt, t_prev_Spike,SpikeProb,Iadd, PSC,
    uuE,uuI,ssE,ssI,IsynE,IsynI, uuE_old,ssE_old,
    gAMP3,gAMPA,gGABA,gGABB,gGAB3,gNMD3,gNMDA,
    Im,I_GJ                                  :array[1..3] of double;
    VFunc                                    :vect;
    FreqUS                                   :matr;
    SmplFile                                 :array[0..MaxSmpls] of string;
    { Hodgkin }
    alAMPA,alGABA,alGABB,alNMDA,beAMPA,beGABA,beGABB,beNMDA,
    alAMP3,alGAB3,beAMP3,beGAB3,
    mAMP3,mAMPA,mGABA,mGABB,mGAB3,mNMD3,mNMDA,
    UAMP3,UAMPA,UGABA,UGABB,UGAB3,UNMD3,UNMDA,
    WAMP3,WAMPA,WGABA,WGABB,WGAB3,WNMD3,WNMDA,
    gGJ_E,gGJ_I,
    eAMP,UeAMP,WeAMP,eGAB,UeGAB,WeGAB,
    C_membr,mm,nn,yK,hh,ii,nM,lM,nA,lA,mCaH,hCaH,nKCa,Ca,
    wAHP,mBst,UBst,WBst, mNaP,VK,
    DuDtmax,VThr0,ThrCorrection,sgm_V,dT_AP,nn_AP,Vreset,
    gNa,gK,gKA,gKM,gAHP,gNaP,gBst, Square,tau_m, Gs,
    gam,a_axon,r_Noise
                                                            :vect2;
    IfSet_gL_or_tau                          :array[1..2] of integer;
    du,ds,ActiveConductance,FRT,
    roE,roI,gCaH,gKCa,VNa,VKA,VKM,VAHP,Vus,
    yK_AP,nA_AP,lA_AP,dwAHP,
    Transm, dt_T,Tr,tau_Bst,
    VAMPA,VGABA,VGABA0,VGABB,VNMDA,Mg, VexpMax,VmodMax, Vr,
    t,t_end,dt,dt2, t0s,tSt,dtSt, AmplOfNoise, minDVDt,
    Qns, Functional,
    xU,yU,p_sc,V_sc,I_sc,VI_sc,sc_Simplex,
    shift_Smp,scx_Smpl,scy_Smpl,
    I_ind, nu_Ind,t_ind,t_Exp,Iext,pext,pext_Iext,factorE,factorI,
    tauNoise,NoiseToSgn,
    x_sc,y_sc,x_shift,y_shift,shift_step,x_pole,y_pole,
    t_prev_writing, degree, PlotWindow

                                                            :double;
    nStimuli,If_I_V_or_p, IfUndimensionate,NSmpls,IfSimplex,
    IfDataStartsFromZero,
    IfBlockAMPA,IfBlockGABA,IfBlockGABB,IfBlockNMDA,IfBlockK,
    IfChangeVrest, IfInSyn_al_EQ_beta, i3, IfAMPAGABAinp_NE_local,
    IfSigmoidForPresynRate, IfEqForVGABA,
    IfPhase, IfSecondOrder,
    DrawOrNot,WriteOrNot,YesToClean,n_show,n_DrawPhase,n_Write,
    IfReadHistory,IfSigmoidFound,
    iHist,SigmOrLinear, istop,nFunk, Smpl,KeepParams,ief,jef
                                                            :integer;
    nt,nt_end                                               :longint;
    HH_type,HH_order                         :array[1..3] of string;
    aaa,ggg,ccc,qqq,ttt,ddd,nnn,xxx,sss,fff                 :text;
    MainDir                                                 :string;

{======================================================================}
{*******************   2-D   ******************************************}
{======================================================================}

Const mXMax=201; mYMax=21;
type
     arr_4_X_Y=array[1..3,0..MaxPh,0..mXmax,0..mYMax] of double;
     arr_3_X_Y=array[1..3,0..mXmax,0..mYMax] of double;
     arr_X_Y  =array[0..mXmax,0..mYMax] of double;
Var
    Wro,WV0_ph,WVE_ph,WDuDt_ph,
    Wnn_ph,WyK_ph,WnA_ph,WlA_ph,WnM_ph,WwAHP_ph,
    WIsynE_ph,WIsynI_ph
                                                       :arr_4_X_Y;
    WQ,WdQdt,Vm,WDuDt,WVatE,Wp,Wpn,Wpo, Wr_noise,
    Wu,Wv,Ww, Wpp,Wup,Wvp, Wun,Wvn,
    W_mAMP3,W_mAMPA,W_mGABB,W_mGABA,W_mGAB3,W_mNMD3,W_mNMDA,
    W_UAMP3,W_WAMP3,W_UGAB3,W_WGAB3,W_UAMPA,W_WAMPA,
    W_UGABA,W_WGABA,W_UGABB,W_WGABB,W_UNMD3,W_WNMD3,W_UNMDA,W_WNMDA,
    W_eAMP,W_UeAMP,W_WeAMP,W_eGAB,W_UeGAB,W_WeGAB,
    W_ss,W_uu,W_ssE,W_ssI,W_uuE,W_uuI, W_wAHP
                                                       :arr_3_X_Y;
    ni,nj,ni_2,nj_2,R_stim,ni_stim,nj_stim,i_view,j_view,
    OrderOfWaveEq
                                                       :integer;
    dx,dy,dx2,dy2, dt_out,X_stim
                                                       :double;

{procedure Warning(t1 :string); forward;
function BurstOfAPs(u,DuDt,VTh :double) :double; forward;}
{--------------------EOF---------------------------------------------------}
implementation

end.
