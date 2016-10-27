unit typeNrnPars;
{ Parameters and variables used in TNeuron and its descendants }

interface
type
  tVThreshold2 = function(DVDt,ThrCorrection,ts :double) :double;
  tIfSpikeOccursInThrModel = procedure(V_,Thr,ddV:double;
   var tAP_:double;
   var indic_:integer);
  { Parameters: }
  NeuronProperties =record
    HH_type,HH_order,NaR_type
                                                            :string;
    indic,
    IfBlockNa,IfBlockK,IfBlockKM,IfBlockKA,IfBlockKD,IfBlockPass,IfBlockNaR,
    IfBlockH,IfBlockAHP,IfBlockCaT,IfBlockCaH,IfBlockKCa,IfBlockBst,
    IfReduced,IfThrModel,IfLIF,
    IfSet_gL_or_tau,IfSet_VL_or_Vrest,If_I_V_or_g
                                                            :integer;
    n_AP,yK_AP,nA_AP,lA_AP,dT_AP,dwAHP,yH_AP,xD_AP,
    ThrShift,FixThr,
    Vreset,tau_abs,
    gL,VL,Square,tau_m,ro,Vrest,C_membr,
    gNa,gNaR,gK,gKM,gKA,gKD,gCaH,gKCa,gAHP,gCaT,gBst,gNaP,gH,
    VNa,VNaR,VK,VKDr,VKM,VKD,V12H,
    a1Na,a2Na,a3Na,a4Na,b1Na,b2Na,b3Na,b4Na,
    c1Na,c2Na,c3Na,c4Na,d1Na,d2Na,d3Na,d4Na,
    a1NaR,a2NaR,a3NaR,a4NaR,b1NaR,b2NaR,b3NaR,b4NaR,
    c1NaR,c2NaR,c3NaR,c4NaR,d1NaR,d2NaR,d3NaR,d4NaR,
    Tr,Tr_NaR, NaThreshShift,
    FRT,Ca8,Ca0,d_Ca,tauCa,Rgas,Temperature,Faraday
                                                            :double;
    { External functions }
    VThreshold2                                             :tVThreshold2;
    IfSpikeOccursInThrModel                                 :tIfSpikeOccursInThrModel;
  end;

  { Variables: }
  NeuronVariables =record
    indic                                                   :integer;

    V,Conductance,Ca,Vold,Im,PSC,IsynE,IsynI,IsynE_old,
    VatE,DVlinDt,ddV,Thr,tAP,
    mmR,hhR,mm,nn,hh,ii,yK,yKA, nM,nA,lA,yH,mCaH,hCaH,kCaH,nKCa,
    wAHP, mCaT,hCaT, mBst,mNaP, xD,yD
                                                            :double;
  end;

var
    t,dt    :double;

implementation

end.

