program lab27_11;
{���������� �������� �. �.
������� ���� ����� ����� ��������� ������ ��������� ������}

{$APPTYPE CONSOLE}

uses
 Windows;

type
uk=^btree;    // ��������� �� ����
btree=record     // �������� ������
  Tag:char;       // ��� ����
  L,R:uk;      // ��������� �� ��������
end;

function Rus(mes: string):string;
var
  i: integer;
begin
  for i:=1 to length(mes) do
   case mes[i] of
     '�'..'�':mes[i] := Chr(Ord(mes[i]) - 64);
     '�'..'�':mes[i]:= Chr (Ord(mes [i] ) -16);
   end;
  rus := mes;
end;

{����������� �������}
procedure GotoXY(x,y:integer);
var
 XY:COORD;
begin
 XY.X:=x;
 XY.Y:=y;
 SetConsoleCursorPosition(GetStdHandle(STD_OUTPUT_HANDLE),XY);
end;

{����� ���� � ���������}
procedure PrintNode(V:uk; X, Y, dx:integer); //�,y ������� ����������
var
 idx,i: integer;
begin
 idx:=Trunc(dx+0.5);   // �������� �������, dx - ������ �����
 GotoXY(X,Y);
 Write(V.Tag);
 if V.L<>nil then      // ����� ����� �����
 begin
    GotoXY(X-idx,Y);
    if(idx<>0) then
      Write(#218);
    for i:=1 to idx-1 do
      Write(#196);
    PrintNode(V.L,X-idx,Y+1,dx div 2);  // �����-���� + �������
 end;
 if V.R<>nil then      // ����� ������ �����
 begin
    GotoXY(X+1,Y);
    for i:=1 to idx-1 do
      Write(#196);
    if idx<>0 then
      Write(#191);
    PrintNode(V.R,X+idx,Y+1,dx div 2); //�����-��� + �������
 end;
end;

{�������� ���� � ���������}
function MakeNode(Depth:integer; var Tag:char):uk; //depth - ���. �������
begin
 Result:=nil;
 if (Depth<Random(6)+1) and (Tag<='Z') then //��� ������, ��� ������ ���� ��������
 begin
    new(Result);
    Result.Tag:=Tag;
    Inc(Tag);
    Result.L:=MakeNode(Depth+1,Tag);   // ����� �������
    Result.R:=MakeNode(Depth+1,Tag);   // � ������
 end;
end;

{����� � ������� ���� �� ����� �� ���� tag}
function Search(V:uk; Tag:char):string;
begin
 Result:=V.Tag;
 if V.Tag=Tag then
    exit;     //���� ��� �������
 if V.L<>nil then
    Result:=Result+Search(V.L,Tag);   //��� ������ �������
 if V.R<>nil then
    Result:=Result+Search(V.R,Tag);  //��� ������� �������
 if Result[Length(Result)]<>Tag then
    delete(Result,Length(Result),1);  //����� �� ����
end;

{������������ ����}
function GetPath(V:uk; a,b:char):string;
var
 WayA,WayB:string;
 Buf:char;
 i:integer;
begin
 WayA:=Search(V,a);
 WayB:=Search(V,b);
 if (WayA='') or (WayB='') then   // ��� ���� = ������
 begin
    Result:=Rus('���� �� ������. ���������� ������������ �����');
    exit;
 end;
 repeat
    Buf:=WayA[1];         // ��������� ����� ������ � �����
    delete(WayA,1,1);     // ������� �����
    delete(WayB,1,1);
 until (Length(WayA)=0) or (Length(WayB)=0) or (WayA[1]<>WayB[1]);
 Result:='';
 for i:=Length(WayA) downto 1 do
    Result:=Result+WayA[i];
 Result:=Result+Buf+WayB;   //���������� ��������� ����� ������
end;


{�������� �����}
var
 Tree:uk;
 Tag:char='A';
 a,b:char;
begin
 Randomize;
 Tree:=MakeNode(0,Tag);
 PrintNode(Tree,40,0,20);
 GotoXY(0,10);             //������ ��� ������
 Write (Rus('���� ��: '));     //���� ������ � �����
 Readln(a);
 Write (Rus('���� �: '));
 Readln(b);
 Writeln (rus('������� ����: '));
 write(GetPath(Tree,a,b));
 Readln;
end.
