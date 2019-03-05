#define _USE_MATH_DEFINES
#include <math.h> 
#ifndef M_PI 
	#define M_PI 3.1415926535897932384626433832795 
#endif
#include <stdio.h>
#include <limits>
#include "mex.h"
#ifndef M_LOG2_E 
	#define M_LOG2_E 0.693147180559945309417 
#endif
#define log2(x) (log(x) / M_LOG2_E)
#define NMAX    20
#define ITMAX  200
typedef double MAT[NMAX][NMAX];

// quick derivitive of mi_hpv to give four corner update locations for imtransform
void corners(double xTrans, double yTrans, double theta, long nX, long nY, double *q){
	
	double hyp, theta_0, xOff, yOff;
	long x,y;

	xOff = ((double)nX-1.0)/2.0;
	yOff = ((double)nY-1.0)/2.0;

	y=0; x = 0; 
	hyp = sqrt((x-xOff)*(x-xOff)+(yOff-y)*(yOff-y));
	theta_0 = acos((yOff-y)/hyp);
	q[0] = -hyp*cos(theta+theta_0)+yTrans+yOff;
	q[1] = -hyp*sin(theta+theta_0)+xTrans+xOff;
	
	y = nY-1; x=0;
	hyp = sqrt((xOff-x)*(xOff-x)+(y-yOff)*(y-yOff));
	theta_0 = acos((xOff-x)/hyp);
	q[2] = hyp*sin(theta+theta_0)+yTrans+yOff;
	q[3] = -hyp*cos(theta+theta_0)+xTrans+xOff;

	y=nY-1; x=nX-1; 
	hyp = sqrt((x-xOff)*(x-xOff)+(y-yOff)*(y-yOff));
	theta_0 = acos((y-yOff)/hyp);
	q[4] = hyp*cos(theta+theta_0)+yTrans+yOff;
	q[5] = hyp*sin(theta+theta_0)+xTrans+xOff;

	y=0; x = nX-1;
	hyp = sqrt((x-xOff)*(x-xOff)+(yOff-y)*(yOff-y));
	theta_0 = acos((x-xOff)/hyp);
	q[6] = -hyp*sin(theta+theta_0)+yTrans+yOff;
	q[7] = hyp*cos(theta+theta_0)+xTrans+xOff;

}
// Uses HPV interpolation algoritm 
// Lu X, et al., Mutual information-based multimodal image registration using a novel joint histogram estimation, 
// Comput Med Imaging Graph (2008), doi:10.1016/j.compmedimag.2007.12.001
// Author: Matthew Sochor
// Date: 2/20/2008
// contact: matthew.sochor@gmail.com
// Other functions (other than main control function) are modified from the below comment author. 
// Only modification is to output negative MI (so maximization problem becomes a minimization problem) and to pass 
// extra needed arrays for the mi_hpv "function"

double mi_hpv(unsigned char *R, unsigned char *F, double xTrans, double yTrans, double theta, long nX, long nY){

	// First compute where each point lies based upon first
	// rotating regular grid by theta (counter-clockwise)
	// then translating grid x and y
	double f_d_kmx, f_d_kmy, theta_0, hyp, qkx, qky, H_A=0.0, H_B=0.0, H_AB=0.0, hsum=0;
	double *P_A = new double[nX],  *P_B = new double[nY], *h = new double[256*256]; 
	long Rx, Ry, hx, hy; 
	double xOff, yOff, xTemp, yTemp, xStart, yStart;
	int j, k;

	xOff = ((double)nX-1.0)/2.0;
	yOff = ((double)nY-1.0)/2.0;

	// initialize histogram for MI measurement
	// 0-255 values correspond to unsigned char (uint8 matlab)
	// signal intensity values
	for(long xx=0; xx<256; xx++){
		for(long yy=0; yy<256; yy++){
			h[xx*256+yy] = 0;
		}
	}
	
	for(double x=0; x<nX; x++){
		for(double y=0; y<nY; y++){
			if (x==xOff){
				if (y==yOff){
					// no rotation just translation, this is the pivot point
					qkx = xTrans+xOff;
					qky = yTrans+yOff;
				}
				else{
					// on y-axis
					qkx = (y-yOff)*sin(theta)+xTrans+xOff;
					qky = (y-yOff)*cos(theta)+yTrans+yOff;
				}
			}
			else if ((x>xOff)&&(y<yOff)){
				// 1st quadrant
				hyp = sqrt((x-xOff)*(x-xOff)+(yOff-y)*(yOff-y));
				theta_0 = acos((x-xOff)/hyp);
				qkx = hyp*cos(theta+theta_0)+xTrans+xOff;
				qky = -hyp*sin(theta+theta_0)+yTrans+yOff;
			}
			else if ((x<xOff)&&(y<yOff)){
				// 2nd quadrant
				hyp = sqrt((x-xOff)*(x-xOff)+(yOff-y)*(yOff-y));
				theta_0 = acos((yOff-y)/hyp);
				qkx = -hyp*sin(theta+theta_0)+xTrans+xOff;
				qky = -hyp*cos(theta+theta_0)+yTrans+yOff;
			}
			else if ((x<xOff)&&(y>yOff)){
				// 3rd quadrant
				hyp = sqrt((xOff-x)*(xOff-x)+(y-yOff)*(y-yOff));
				theta_0 = acos((xOff-x)/hyp);
				qkx = -hyp*cos(theta+theta_0)+xTrans+xOff;
				qky = hyp*sin(theta+theta_0)+yTrans+yOff;
			}
			else if ((x>xOff)&&(y>yOff)){
				// 4th quadrant
				hyp = sqrt((x-xOff)*(x-xOff)+(y-yOff)*(y-yOff));
				theta_0 = acos((y-yOff)/hyp);
				qkx = hyp*sin(theta+theta_0)+xTrans+xOff;
				qky = hyp*cos(theta+theta_0)+yTrans+yOff;
			}
			else{
				// on x-axis
				qkx = (x-xOff)*cos(theta)+xTrans+xOff;
				qky = -(x-xOff)*sin(theta)+yTrans+yOff;
			}

			
			// Find starting point and distance of qkx,qky from convolution point
			// If distances are outside the range 0-nX-1,ny-1 then wrap around
			// Valid if you assume infinitely repeating data
			// build histogram as per HPV algorithm as referenced above
			
			xStart = floor(qkx);
			yStart = floor(qky);
			for (double l1=-1; l1<3; l1++){
				xTemp = xStart+l1;
				if (xTemp < 0){ Rx = (long)(xTemp+nX);}
				else if (xTemp > nX-1){ Rx = (long)(xTemp-nX);}
				else{ Rx=(long)xTemp;}
				f_d_kmx = (1+cos(M_PI*(qkx-xTemp)/2))/4;
				for (double l2=-1; l2<3; l2++){
					yTemp = yStart+l2;
					if (yTemp < 0){ Ry = (long)(yTemp+nY);}
					else if (yTemp > nY-1){ Ry = (long)(yTemp-nY);}
					else{ Ry = (long)yTemp;}
					f_d_kmy = (1+cos(M_PI*(qky-yTemp)/2))/4;
					// update histogram
					hx = F[(long)x*nY+(long)y];
					hy = R[Rx*nY+Ry];
					h[hx*256+hy] += f_d_kmx*f_d_kmy;
				}
			}
		}
	}

	// Determine entropies and joint entropy
	for (j=0;j<256;j++){
		for (k=0;k<256;k++){
			hsum += h[j*256+k];
		}
	}
	for (j=0;j<256;j++){
		for (k=0;k<256;k++){
			if (k==0) {P_A[j] = h[j*256]/hsum; }// init across j
			else{P_A[j]+=h[j*256+k]/hsum;} // add across j
			if (j==0) {P_B[k] = h[k]/hsum;} // init across k
			else {P_B[k]+=h[j*256+k]/hsum;} // add across k
			if (h[j*256+k] != 0){H_AB-=h[j*256+k]/hsum*log2(h[j*256+k]/hsum);} // add j-k
		}
	}
	for (j=0;j<256;j++){
		if (P_A[j] != 0){H_A-=P_A[j]*log2(P_A[j]);}
		if (P_B[j] != 0){H_B-=P_B[j]*log2(P_B[j]);}
	}
	free(P_A);
	free(P_B);
	free(h);
	return(H_A+H_B-H_AB);
}

/*************************************************************
* Minimization of a Function FUNC of N Variables By Powell's *
*    Method Discarding the Direction of Largest Decrease     *
* ---------------------------------------------------------- *
* SAMPLE RUN: Find a minimum of function F(x,y):             *
*             F=Sin(R)/R, where R = Sqrt(x*x+y*y).           *
*                                                            *
* Number of iterations: 2                                    *
*                                                            *
* Minimum Value: -0.217234                                   *
*                                                            *
* at point: 3.177320  3.177320                               *
*                                                            *
* ---------------------------------------------------------- *
* REFERENCE: "Numerical Recipes, The Art of Scientific       *
*             Computing By W.H. Press, B.P. Flannery,        *
*             S.A. Teukolsky and W.T. Vetterling,            *
*             Cambridge University Press, 1986"              *
*             [BIBLI 08].                                    *
*                                                            *
*                         C++ Release By J-P Moreau, Paris.  *
*************************************************************/
/* Code source link: http://pagesperso-orange.fr/jean-pierre.moreau/Cplus/tpowell_cpp.txt */

double P[NMAX];
MAT    XI;

double PCOM[NMAX], XICOM[NMAX];  //PCOM,XICOM,NCOM are common variables
int    ITER,N,NCOM;              //for LINMIN and F1DIM only
double FRET,FTOL;

// user defined function to minimize
double FUNC(unsigned char *R, unsigned char *F, long nX, long nY, double *P) {
	
	double MI;	
	MI = mi_hpv(R, F, P[1], P[2], P[3], nX, nY);
	return(-1.0*MI); // Return negative Mutual Information to change maximization into a minimazation
}

double MAX(double a,double b) {
  if (a>=b) return a; else return b;
}

double MIN(double a,double b) {
  if (a<=b) return a; else return b;
}

double Sign(double a, double b) {
  if (b>=0) return fabs(a);
  else return -fabs(a);
}

double Sqr(double a) {
  return a*a;
}

void   LINMIN(unsigned char *, unsigned char *, long, long, double *, double *, int, double *);
void   MNBRAK(unsigned char *, unsigned char *, long, long, double *, double *, double *, double *, double *, double *);
double BRENT (unsigned char *, unsigned char *, long, long, double *, double *, double *, double, double *);

void POWELL(unsigned char *R, unsigned char *F, long nX, long nY, double *P, MAT XI, int N, double FTOL,int *ITER, double *FRET) {
/*--------------------------------------------------------------------------
  Minimization of a function  FUNC of N variables  (FUNC is not an argument, 
  it is a fixed function name). Input consists of an initial starting point 
  P, that is a vector of length N; an initial matrix XI  whose  logical 
  dimensions are N by N, physical dimensions NMAX by NMAX, and whose columns
  contain the initial set of directions (usually the N unit vectors); and 
  FTOL, the fractional tolerance in the function value such that failure to 
  decrease by more than this amount on one iteration signals doneness. On 
  output, P is set to the best point found, XI is the then-current direction 
  set,  FRET is the returned function value at P, and ITER is the number of 
  iterations taken. The routine LINMIN is used.
---------------------------------------------------------------------------*/
// Label: e1
  double PT[NMAX], PTT[NMAX], XIT[NMAX];
  double DEL,FP,FPTT,T;
  int I,IBIG,J;
  *FRET=FUNC(R,F,nX,nY,P);
  for (J=1; J<=N; J++)
    PT[J]=P[J];            //Save initial point
  *ITER=0;
e1:*ITER=*ITER+1;
  FP=*FRET;
  IBIG=0;
  DEL=0.0;                 //Will be the biggest function decrease
  for (I=1; I<=N; I++) {   //In each iteration, loop over all directions in the set.
    for (J=1; J<=N; J++)   //Copy the direction.
      XIT[J]=XI[J][I];
    FPTT=*FRET;
    LINMIN(R, F, nX, nY,P,XIT,N,FRET);  //Minimize along it
    if (fabs(FPTT-*FRET) > DEL) {
      DEL=fabs(FPTT-*FRET);
      IBIG=I;
    }
  }
  if (2.0*fabs(FP-*FRET) <= FTOL*(fabs(FP)+fabs(*FRET))) return; //Termination criterion
  if (*ITER == ITMAX) {
    printf("\n Powell exceeding maximum iterations.\n\n");
    return;
  }
  for (J=1; J<=N; J++) {
    PTT[J]=2.0*P[J]-PT[J]; //Construct the extrapolated point and the average
    XIT[J]=P[J]-PT[J];     //direction moved. Save the old starting point
    PT[J]=P[J];
  }
  FPTT=FUNC(R,F,nX,nY,PTT);              //Function value at extrapolated point
  if  (FPTT >= FP) goto e1;    //One reason not to use new direction
  T=2.0*(FP-2.0*(*FRET)+FPTT)*Sqr(FP-(*FRET)-DEL)-DEL*Sqr(FP-FPTT);
  if (T >= 0.0) goto e1;       //Other reason not to use new direction
  LINMIN(R, F, nX, nY,P,XIT,N,FRET);        //Move to the minimum of the new direction
  for (J=1; J<=N; J++)         //and save the new direction.
    XI[J][IBIG]=XIT[J];
  goto e1;
} //Powell()

void   LINMIN(unsigned char *R, unsigned char *F, long nX, long nY, double *P, double *XI, int N, double *FRET) {
/*---------------------------------------------------------
  Given an N dimensional point P and a N dimensional direc-
  tion XI, moves and resets P to where the function FUNC(P)
  takes on a minimum along the direction XI from P, and
  replaces XI by the actual vector displacement that P was
  moved. Also returns as FRET the value of FUNC at the
  returned location P. This is actually all accomplished by
  calling the routines MNBRAK and BRENT.
---------------------------------------------------------*/
  double AX,BX,FA,FB,FX,TOL,XMIN,XX;
  int J;
  TOL=1e-4;
  NCOM=N;
  for (J=1; J<=N; J++) {
    PCOM[J]=P[J];
    XICOM[J]=XI[J];
  }
  AX=0.0;
  XX=1.0;
  BX=2.0;
  MNBRAK(R,F,nX,nY,&AX,&XX,&BX,&FA,&FX,&FB);
  *FRET=BRENT(R,F,nX,nY,&AX,&XX,&BX,TOL,&XMIN);
  for (J=1; J<=N; J++) {
    XI[J]=XMIN*XI[J];
    P[J] += XI[J];
  }
}


double F1DIM(unsigned char *R, unsigned char *F, long nX, long nY, double X) {
  double XT[NMAX]; int J;
  for (J=1; J<=NCOM; J++)
    XT[J]=PCOM[J] + X*XICOM[J];
  return FUNC(R,F,nX,nY,XT);
}

void   MNBRAK(unsigned char *Ref, unsigned char *F, long nX, long nY, double *AX,double *BX,double *CX,
			  double *FA, double *FB, double *FC)  {
/*---------------------------------------------------------------------
 Given a Function F1DIM(X), and given distinct initial points AX and
 BX, this routine searches in the downhill direction (defined by the
 Function as evaluated at the initial points) and returns new points
 AX, BX, CX which bracket a minimum of the Function. Also returned
 are the Function values at the three points, FA, FB and FC.
---------------------------------------------------------------------*/
  //Label:  e1
  const double GOLD=1.618034, GLIMIT=100.0, TINY=1e-20;
/*The first parameter is the default ratio by which successive intervals
  are magnified; the second is the maximum magnification allowed for
  a parabolic-fit step. */

  double DUM,FU,Q,R,U,ULIM;
  *FA=F1DIM(Ref,F,nX,nY,*AX);
  *FB=F1DIM(Ref,F,nX,nY,*BX);
  if (*FB > *FA) {
    DUM=*AX;
    *AX=*BX;
    *BX=DUM;
    DUM=*FB;
    *FB=*FA;
    *FA=DUM;
  }
  *CX=*BX+GOLD*(*BX-*AX);
  *FC=F1DIM(Ref,F,nX,nY,*CX);
e1:if (*FB >= *FC) {
    R=(BX-AX)*(FB-FC);
    Q=(BX-CX)*(FB-FA);
    U=*BX-((*BX-*CX)*Q-(*BX-*AX)*R)/(2.0*Sign(MAX(fabs(Q-R),TINY),Q-R));
    ULIM=*BX+GLIMIT*(*CX-*BX);
    if ((*BX-U)*(U-*CX) > 0.0) {
      FU=F1DIM(Ref,F,nX,nY,U);
      if (FU < *FC) {
        *AX=*BX;
        *FA=*FB;
        *BX=U;
        *FB=FU;
        goto e1;
      }
      else if (FU > *FB) {
        *CX=U;
        *FC=FU;
        goto e1;
      }
      U=*CX+GOLD*(*CX-*BX);
      FU=F1DIM(Ref,F,nX,nY,U);
    }
    else if ((*CX-U)*(U-ULIM) > 0.0) {
      FU=F1DIM(Ref,F,nX,nY,U);
      if (FU < *FC) {
        *BX=*CX;
        *CX=U;
        U=*CX+GOLD*(*CX-*BX);
        *FB=*FC;
        *FC=FU;
        FU=F1DIM(Ref,F,nX,nY,U);
      }
    }
    else if ((U-ULIM)*(ULIM-*CX) >= 0.0) {
      U=ULIM;
      FU=F1DIM(Ref,F,nX,nY,U);
    }
    else {
      U=*CX+GOLD*(*CX-*BX);
      FU=F1DIM(Ref,F,nX,nY,U);
    }
    *AX=*BX;
    *BX=*CX;
    *CX=U;
    *FA=*FB;
    *FB=*FC;
    *FC=FU;
    goto e1;
  }  
}


double BRENT(unsigned char *Ref, unsigned char *F, long nX, long nY, double *AX,double *BX,double *CX, double TOL, double *XMIN) {
/*------------------------------------------------------------------
 Given a function F1DIM, and a bracketing triplet of abscissas AX,
 BX,CX (such that BX is between AX and CX, and F(BX) is less than
 both F(AX) and F(CX)), this routine isolates the minimum to a
 fractional precision of about TOL using Brent's method. The abscissa
 of the minimum is returned in XMIN, and the minimum function value 
 is returned as BRENT, the returned function value.
-------------------------------------------------------------------*/
//Labels: e1,e2,e3
  const double CGOLD=0.3819660, ZEPS=1e-10;
/*Maximum allowed number of iterations; golden ratio; and a small
  number which protects against trying to achieve fractional accuracy
  for a minimum that happens to be exactly zero */
  double A,B,D,E,ETEMP,FX,FU,FV,FW,P,Q,R,TOL1,TOL2,U,V,W,X,XM;
  int ITER;
  A=MIN(*AX,*CX);
  B=MAX(*AX,*CX);
  V=*BX;
  W=V;
  X=V;
  E=0.0;
  FX=F1DIM(Ref,F,nX,nY,X);
  FV=FX;
  FW=FX;
  for (ITER=1; ITER<=ITMAX; ITER++) {                    //main loop
    XM=0.5*(A+B);
    TOL1=TOL*fabs(X)+ZEPS;
    TOL2=2.0*TOL1;
    if (fabs(X-XM) <= (TOL2-0.5*(B-A))) goto e3;     //Test for done here
    if (fabs(E) > TOL1) {               //Construct a trial parabolic fit
      R=(X-W)*(FX-FV);
      Q=(X-V)*(FX-FW);
      P=(X-V)*Q-(X-W)*R;
      Q=0.2*(Q-R);
      if (Q > 0.0) P=-P;
      Q=fabs(Q);
      ETEMP=E;
      E=D;
      if (fabs(P) >= fabs(0.5*Q*ETEMP) || P <= Q*(A-X) || P >= Q*(B-X)) goto e1;
//  The above conditions determine the acceptability of the
//  parabolic fit. Here it is o.k.
      D=P/Q;
      U=X+D;
      if (U-A < TOL2 || B-U < TOL2)  D=Sign(TOL1,XM-X);
      goto e2;
    }
e1: if (X >= XM)
      E=A-X;
    else
      E=B-X;
    D=CGOLD*E;
e2: if (fabs(D) >= TOL1)
      U=X+D;
    else
      U=X+Sign(TOL1,D);
    FU=F1DIM(Ref,F,nX,nY,U);   //This the one function evaluation per iteration
    if (FU <= FX) {
      if (U >= X)
        A=X;
      else
        B=X;
      V=W;
      FV=FW;
      W=X;
      FW=FX;
      X=U;
      FX=FU;
    }
    else {
      if (U < X)
        A=U;
      else
        B=U;
      if (FU <= FW || W == X) {
        V=W;
        FV=FW;
        W=U;
        FW=FU;
      }
      else if (FU <= FV || V == X || V == W) {
        V=U;
        FV=FU;
      }
    }
  }
  printf("\n Brent exceed maximum iterations.\n\n");
e3:*XMIN=X;   //exit section
  return FX;
}








void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {

	if (nrhs != 2) {
		mexErrMsgTxt("Two input arguments required.");
	} else if (nlhs > 3) {
		mexErrMsgTxt("Only three output arguments allowed.");
	}
	if (mxIsUint8(prhs[0])==0){
		mexErrMsgTxt("First input image must be uint8.");
	}
	if (mxIsUint8(prhs[1])==0){
		mexErrMsgTxt("Second input image must be uint8.");
	}
	mexPrintf("Co-registering images, please wait...\n");
	long numX,numY;
	unsigned char *pRef, *pFloat;
	double *pTranslate, *pTranslateOut, *pq, *pq_0;

	N=3;
	P[1]=0.0; P[2]=0.0; P[3]=0.0;
	XI[1][1]=1.0; XI[1][2]=0.0; XI[1][3]=0.0;
	XI[2][1]=0.0; XI[2][2]=1.0; XI[2][3]=0.0;
	XI[3][1]=0.0; XI[3][2]=0.0; XI[3][3]=1.0;

	FTOL=1e-8;

	numX = mxGetN(prhs[0]);
	numY = mxGetM(prhs[0]);
	if ((numY != mxGetM(prhs[1])) || (numX != mxGetN(prhs[1]))){
		mexErrMsgTxt("Input images must be the same size.");
	}
//	mexPrintf("y=%d  x=%d\n",numY,numX);
	pRef = (unsigned char *)mxGetPr(prhs[0]);
	pFloat = (unsigned char *)mxGetPr(prhs[1]);
	pTranslate = (double *)mxGetPr(prhs[2]);
	plhs[0]=mxCreateDoubleMatrix(3,1,mxREAL);
	pTranslateOut = (double *)mxGetPr(plhs[0]);
	POWELL(pRef,pFloat,numX,numY,P,XI,N,FTOL,&ITER,&FRET);
	pTranslateOut[0]=P[1];
	pTranslateOut[1]=P[2];
	pTranslateOut[2]=P[3];
//	P[1] = 5.13;
//	P[2] = -4.3;
//	P[3] = M_PI_2/3.0;
	mexPrintf("Co-registration complete: dX=%3.1lf  dY=%3.1lf  dTheta=%1.5lf\n",P[1],P[2],P[3]);
	if (nlhs == 2){
		plhs[1]=mxCreateDoubleMatrix(8,1,mxREAL);
		pq = (double *)mxGetPr(plhs[1]);
		corners(P[1],P[2],P[3], numX, numY, pq);
	}
	if (nlhs == 3){
		plhs[1]=mxCreateDoubleMatrix(8,1,mxREAL);
		pq = (double *)mxGetPr(plhs[1]);
		corners(P[1],P[2],P[3], numX, numY, pq);
		plhs[2]=mxCreateDoubleMatrix(8,1,mxREAL);
		pq_0 = (double *)mxGetPr(plhs[2]);
		pq_0[0] = 0.0;
		pq_0[1] = 0.0;
		pq_0[2] = (double)numY-1.0;
		pq_0[3] = 0.0;
		pq_0[4] = (double)numY-1.0;
		pq_0[5] = (double)numX-1.0;
		pq_0[6] = 0.0;
		pq_0[7] = (double)numX-1.0;

	}
}
