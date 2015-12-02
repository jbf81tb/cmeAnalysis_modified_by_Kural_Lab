function [TraceX,TraceY,TraceZ,TraceINT]=AddBlankFrames(TraceX,TraceY,TraceZ,TraceINT,blank)

[A,B]=size(TraceX);
blanks=zeros(A,blank);
TraceX=[blanks TraceX];
TraceY=[blanks TraceY];
TraceZ=[blanks TraceZ];
TraceINT=[blanks TraceINT];