function [DETS,PTS,DESCS]=extfacedescs(opts,I,debug, DETS)

if nargin<3
    debug=false;
end

if debug
    figure(1);
    clf('reset');
    set(gcf,'doublebuffer','on');
    figure(2);
    clf('reset');
    set(gcf,'doublebuffer','on');
end

PTS=zeros(0,0,1);
DESCS=zeros(0,1);
% for i=1:size(DETS,2)
i = 1;
    P=findparts(opts.model,I,DETS(:));
    PTS(1:size(P,1),1:size(P,2),i)=P;
    if debug
        figure;
        imagesc(I);
        hold on;
        plot(DETS(1,i)+DETS(3,i)*[-1 1 1 -1 -1],DETS(2,i)+DETS(3,i)*[-1 -1 1 1 -1],'y-','linewidth',2);
        plot(PTS(1,:,i),PTS(2,:,i),'y+','markersize',10,'linewidth',2);
        hold off;
        axis image;
        colormap gray;
    end
    
    %fd=extdesc(opts.desc,I,PTS(:,:,i),debug);
    %DESCS(1:numel(fd),i)=fd;
    
    if debug
        drawnow;
        if i+1<size(DETS,2)
            pause;
        end
    end
    
% end
