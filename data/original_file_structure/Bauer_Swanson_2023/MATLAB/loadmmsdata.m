% load MMS data 
load ../data/confidential/mms.txt ;

[mmsrows,mmscols] = size(mms) ;
mmsmo = mms(:,1) ;
mmsdy = mms(:,2) ;
mmsyr = mms(:,3) ;
mmscpixexp = mms(:,16) ;
mmscpixrel = mms(:,17) ;
mmsgdpexp = mms(:,22) ;
mmsgdprel = mms(:,23) ;
mmsnfpexp = mms(:,36) ;
mmsnfprel = mms(:,37) ;
mmsunempexp = mms(:,52) ;
mmsunemprel = mms(:,53) ;

% define surprise component of releases
mmscpix = mmscpixrel - mmscpixexp ;
mmsgdp = mmsgdprel - mmsgdpexp ;
mmsnfp = mmsnfprel - mmsnfpexp ;
mmsunemp = mmsunemprel - mmsunempexp ;



