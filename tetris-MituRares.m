%functia principala
function tetris
global h CurrPiece CurrPoint board board2 overlap score
%creez fereastra jocului
h.f = figure('menubar','none','numbertitle','off', 'Toolbar','none', 'name','Tetris', 'position',[100,100,240,460]);
%prop principale
h.a=axes('Position',[0 0 1 1], 'XTick',[],'YTick',[], 'xlim', [0 12], 'ylim', [0 23]);
%definirea formelor
h.pieces{1} = [1 1; 1 1];
h.pieces{2} = [1 1; 0 1; 0 1];
h.pieces{3} = [1 1; 1 0; 1 0];
h.pieces{4} = [0 1 1; 1 1 0];
h.pieces{5} = [1 1 0; 0 1 1];
h.pieces{6} = [1 1 1 1];
h.pieces{7} = [0 1 0; 1 1 1];
%init variabile de stare
CurrPiece = h.pieces{ceil(7*rand)};
CurrPoint = [1 4];
overlap=0;
score=0;
%init matrici pt tabla de joc
board=zeros(20,10);
board2=zeros(20,10);
h.r=zeros(22,12);
%crearea fundalului
h.b=rectangle('Position',[0 0 12 23], 'FaceColor',[.5 .5 .5]);
%matricea pt afisarea  blocurilor
for x=1:10
    for y=1:20
        h.r(x,y) = rectangle('Position',[x y 1 1],'EdgeColor', [1 1 1], 'FaceColor',[1 1 1]);
    end
end
%init prima piesa
board(CurrPoint(1):CurrPoint(1)+size(CurrPiece,1)-1,CurrPoint(2):CurrPoint(2)+size(CurrPiece,2)-1)=CurrPiece;
Board_draw
%functiile pt tastele apasate si butonul de start
set(h.f,'WindowKeyPressFcn', @Key)

h.p1=uicontrol('style','pushbutton','units','normalized','position',[.6 .92 .2 .07],'String','Start~!');
set(h.p1,'Callback', @pushc)
%afisarea scorului
h.txt=text(1, 22.1, ['Scor ' num2str(score)],'color',[.5 .8 0],'fontweight','bold','fontsize',15);
%timer pt miscarile automate
h.t = timer('ExecutionMode', 'FixedRate', 'Period', .3, 'TimerFcn', @timeroff);
start(h.t);
%func pt butonul de start
function pushc(hObject, eventdata)

global h CurrPiece CurrPoint board board2 
   %reset piesa curenta si butonul de start
    CurrPiece=0;
    CurrPiece = h.pieces{ceil(7*rand)};
    CurrPoint = [1 4];
    overlap=0;
    score=0;
    
    board=zeros(20,10);
    board2=zeros(20,10);
    %noua piesa
    temp=logical(board2(CurrPoint(1):CurrPoint(1)+size(CurrPiece,1)-1,CurrPoint(2):CurrPoint(2)+size(CurrPiece,2)-1)+CurrPiece);
    board(CurrPoint(1):CurrPoint(1)+size(CurrPiece,1)-1,CurrPoint(2):CurrPoint(2)+size(CurrPiece,2)-1)=temp;
%deseneaza tabla
    Board_draw
        

function timeroff(hObject, eventdata)

global h CurrPiece CurrPoint board board2 overlap score
%muta piesa curenta in jos
CurrPoint=CurrPoint+[1 0];


temp=0;
if CurrPoint(1)+size(CurrPiece,1)-1<=19 && overlap==0
    temp=logical(board2(CurrPoint(1):CurrPoint(1)+size(CurrPiece,1)-1,CurrPoint(2):CurrPoint(2)+size(CurrPiece,2)-1)+CurrPiece);
    board(CurrPoint(1):CurrPoint(1)+size(CurrPiece,1)-1,CurrPoint(2):CurrPoint(2)+size(CurrPiece,2)-1)=temp;
    Bottom=board2(CurrPoint(1)+1:CurrPoint(1)+size(CurrPiece,1), CurrPoint(2):CurrPoint(2)+size(CurrPiece,2)-1);
    overlap=max(max(CurrPiece.*Bottom));       
elseif CurrPoint(1)+size(CurrPiece,1)-1==20 && overlap==0
    temp=logical(board2(CurrPoint(1):CurrPoint(1)+size(CurrPiece,1)-1,CurrPoint(2):CurrPoint(2)+size(CurrPiece,2)-1)+CurrPiece);
    board(CurrPoint(1):CurrPoint(1)+size(CurrPiece,1)-1,CurrPoint(2):CurrPoint(2)+size(CurrPiece,2)-1)=temp;
    Bottom=board2(CurrPoint(1)+1:CurrPoint(1)+size(CurrPiece,1)-1, CurrPoint(2):CurrPoint(2)+size(CurrPiece,2)-1);
    Bottom=[Bottom; ones(1,size(CurrPiece,2))];
    overlap=max(max(CurrPiece.*Bottom));

else

    overlap=0;
    board2=board;
    CurrPiece=0;
    CurrPiece = h.pieces{ceil(7*rand)};
    CurrPoint = [1 4];
    
    temp=logical(board2(CurrPoint(1):CurrPoint(1)+size(CurrPiece,1)-1,CurrPoint(2):CurrPoint(2)+size(CurrPiece,2)-1)+CurrPiece);
    board(CurrPoint(1):CurrPoint(1)+size(CurrPiece,1)-1,CurrPoint(2):CurrPoint(2)+size(CurrPiece,2)-1)=temp;

    end

if CurrPoint(1)-1>=1
board(CurrPoint(1)-1,CurrPoint(2):CurrPoint(2)+size(CurrPiece,2)-1)=zeros(1,size(CurrPiece,2));
end

if CurrPoint(1)==2 && overlap==1
    stop(hObject)
end

disp([CurrPoint(1) size(board,1) size(board2,1) overlap]);

Board_draw

n=0;
if max(sum(board2,2)==10)
    n=sum(sum(board2,2)==10);
    score=score+n;
    set(h.txt, 'string', ['Scor : ' num2str(score)]);
    board2=[zeros(n,10); board2(~(sum(board2,2)==10),:)];
    board=board2;
Board_draw
end

%func pt tastele apasate
function Key(hobject, eventdata)

global h CurrPiece CurrPoint board board2 overlap

persistent toolbarFlag ;
if isempty(toolbarFlag)    
    toolbarFlag = true;     
end  

c = eventdata.Character;
k = eventdata.Key;
temp=0;

switch c
    case char(27);  
        stop(h.t);
        delete(h.f);
end
        
    switch k
        case 'uparrow'
            if CurrPoint(2)+size(rot90(CurrPiece),2)-1<=10
            board(CurrPoint(1):CurrPoint(1)+size(CurrPiece,1)-1,CurrPoint(2):CurrPoint(2)+size(CurrPiece,2)-1)=zeros(size(CurrPiece));
            CurrPiece=rot90(CurrPiece);
            board(CurrPoint(1):CurrPoint(1)+size(CurrPiece,1)-1,CurrPoint(2):CurrPoint(2)+size(CurrPiece,2)-1)=CurrPiece;
            else
                beep                
            end

        case 'downarrow'
            CurrPoint = CurrPoint + [1 0];
            if CurrPoint(1)-1>=1
            board(CurrPoint(1)-1,CurrPoint(2):CurrPoint(2)+size(CurrPiece,2)-1)=zeros(1,size(CurrPiece,2));
            end
            
        case 'leftarrow'
            if CurrPoint(2)-1>=1
                if max(board2(CurrPoint(1):CurrPoint(1)+size(CurrPiece,1)-1, CurrPoint(2)-1).*CurrPiece(:,1))==0
            board(CurrPoint(1):CurrPoint(1)+size(CurrPiece,1)-1,CurrPoint(2):CurrPoint(2)+size(CurrPiece,2)-1)=zeros(size(CurrPiece));
            CurrPoint = CurrPoint + [0 -1];
            temp=board(CurrPoint(1):CurrPoint(1)+size(CurrPiece,1)-1,CurrPoint(2):CurrPoint(2)+size(CurrPiece,2)-1);
            temp=[zeros(1, size(temp,2)); temp(2:end,:)]; temp=logical(temp+CurrPiece);
            board(CurrPoint(1):CurrPoint(1)+size(CurrPiece,1)-1,CurrPoint(2):CurrPoint(2)+size(CurrPiece,2)-1)=temp;
                end
            else
                beep
            end

        case 'rightarrow'
            if CurrPoint(2)+size(CurrPiece,2)<=10
                if max(board2(CurrPoint(1):CurrPoint(1)+size(CurrPiece,1)-1, CurrPoint(2)+size(CurrPiece,2)).*CurrPiece(:,end))==0
            board(CurrPoint(1):CurrPoint(1)+size(CurrPiece,1)-1,CurrPoint(2):CurrPoint(2)+size(CurrPiece,2)-1)=zeros(size(CurrPiece));
            CurrPoint = CurrPoint + [0 1];
            temp=board(CurrPoint(1):CurrPoint(1)+size(CurrPiece,1)-1,CurrPoint(2):CurrPoint(2)+size(CurrPiece,2)-1);
            temp=[zeros(1, size(temp,2)); temp(2:end,:)]; temp=logical(temp+CurrPiece);
            board(CurrPoint(1):CurrPoint(1)+size(CurrPiece,1)-1,CurrPoint(2):CurrPoint(2)+size(CurrPiece,2)-1)=temp;
                end
            else
                beep
            end
                        
        otherwise
            beep
    end

temp=0;
if CurrPoint(1)+size(CurrPiece,1)-1<=19
    temp=logical(board2(CurrPoint(1):CurrPoint(1)+size(CurrPiece,1)-1,CurrPoint(2):CurrPoint(2)+size(CurrPiece,2)-1)+CurrPiece);
    board(CurrPoint(1):CurrPoint(1)+size(CurrPiece,1)-1,CurrPoint(2):CurrPoint(2)+size(CurrPiece,2)-1)=temp;
    Bottom=board2(CurrPoint(1)+1:CurrPoint(1)+size(CurrPiece,1), CurrPoint(2):CurrPoint(2)+size(CurrPiece,2)-1);
    overlap=max(max(CurrPiece.*Bottom));  
else
    temp=logical(board2(CurrPoint(1):CurrPoint(1)+size(CurrPiece,1)-1,CurrPoint(2):CurrPoint(2)+size(CurrPiece,2)-1)+CurrPiece);
    board(CurrPoint(1):CurrPoint(1)+size(CurrPiece,1)-1,CurrPoint(2):CurrPoint(2)+size(CurrPiece,2)-1)=temp;
    Bottom=board2(CurrPoint(1)+1:CurrPoint(1)+size(CurrPiece,1)-1, CurrPoint(2):CurrPoint(2)+size(CurrPiece,2)-1);
    Bottom=[Bottom; ones(1,size(CurrPiece,2))];
    overlap=max(max(CurrPiece.*Bottom));
end
    
Board_draw


function Board_draw

global h CurrPiece CurrPoint board board2

m=flip(board);

for x=1:10
    for y=1:20
        set(h.r(x,y), 'EdgeColor', [~m(y,x) ~m(y,x) ~m(y,x)], 'FaceColor',[~m(y,x) ~m(y,x) ~m(y,x)]);
    end
end

drawnow