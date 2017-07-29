function [input2]=NLMedianFilter(input,t,f,np)
 %  input: image to be filtered
 %  t: radio of search window
 %  f: radio of similarity window
 %  np: number of similar patches
 % Size of the image
 [m n]=size(input);
 
 % Memory for the output
  
 distance=zeros(2*t+1,2*t+1);

 % Replicate the boundaries of the input image
 input2 = padarray(input,[f f],'symmetric');
 count = 0;
 for i=1:m
 for j=1:n
         i1 = i+ f;
         j1 = j+ f;
         if (input2(i1,j1) == 0 || input2(i1,j1) == 255)    
            W1= input2(i1-f:i1+f , j1-f:j1+f);
         
            rmin = max(i1-t,f+1);
            rmax = min(i1+t,m+f);
            smin = max(j1-t,f+1);
            smax = min(j1+t,n+f);
            distance=zeros(rmax-rmin+1,smax-smin+1);
            t1 = 1;
            t2 = 1;
            for r=rmin:rmax
                t2 = 1;
                for s=smin:smax                                    
                    if(r==i1 && s==j1)
                        count=count+1; 
                    end;                   
                    W2= input2(r-f:r+f , s-f:s+f);                
                    distance(t1,t2) = sqrt(sum(sum((W1-W2).*(W1-W2))));
                    t2 = t2+1;
                end;
                t1 = t1+1;
            end;
            %disp(distance);
            tempd = sort(distance(:));
            minm = tempd(1:np);
            %disp(tempd);
            k=1;
            v = 1;
            while k<=np
                [row col] = find(distance==minm(k));
                %disp(minm(k));
                num = size(row,1);
                temp = k;
                k = k+num;
                if(k>np+1)
                    row = row(1:np-temp+1);
                    col = col(1:np-temp+1);
                end;    
                row = row+(rmin-1);
                col = col+(smin-1);
                noi = size(row,1);
                for l=1:noi
                    sim = input2(row(l)-f:row(l)+f,col(l)-f:col(l)+f);
                    sim = sim(:)';
                    len = size(sim,2);
                    u=v+len-1;
                    %disp(v);
                    %disp(u);
                    values(v:u) = sim;
                    v = v+len;
                    %disp(v);
                    %disp(values)
                end
                %if(values(:)==W1(:))
                    %count=count+1;
                %end
            end
            
            values=values(values~=0);
            values=values(values~=255);
            values=values(:);
            %disp(sort(values));
            lenVal=size(values,1);
            if (lenVal ~= 0)
                med=median(values);
                input2(i1,j1)=med;
            else
                input2(i1,j1) = input2(i1,j1-1);
                %disp(input2(i1,j1));
                %count=count+1;
            end
         end
 end
 end
input2=input2(f+1:f+m,f+1:f+n);
return

         