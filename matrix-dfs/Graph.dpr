program lab32_11;
{���������� �������� �. �.
}


{$APPTYPE CONSOLE}


type
 TMatrix=array of array of integer;  //������������ �������

function Rus(mes: string):string;
var
  i: integer; // ����� ��������������� �������
begin
  for i:=1 to length(mes) do
   case mes[i] of
     '�'..'�':mes[i] := Chr(Ord(mes[i]) - 64);
     '�'..'�': mes[i]:= Chr (Ord(mes [i] ) -16);
   end;
  rus := mes;
end;

{�������� ������� �� �����}
function LoadMatrix(const FileName:string):TMatrix;
var
 F:TextFile;
 S:string;
 j:integer;
begin
 Result:=nil;
 AssignFile(F,FileName);
 try
    Reset(F);
 except
    exit;
 end;
 while not EOF(F) do
 begin
    Readln(F,S);
    SetLength(Result,Length(Result)+1);                  //��. ������
    SetLength(Result[High(Result)],Length(S)+1);         //��. ������
    for j:=1 to Length(S) do                             //��������
      Result[High(Result),j-1]:=ord(S[j])-ord('0');
    Result[High(Result),High(Result[High(Result)])]:=0;  //��������� ������� ������ ������ - ���� ����� � DFS
 end;
 CloseFile(F);
end;

{����� �������}
procedure PrintMatrix(const M:TMatrix);
var
 i,j:integer;
 c:char;
begin
 if M=nil then
 begin
    Writeln(rus('Matrix is empty!'));
    exit;
 end;
 c:='A';                      //���������� ������ �� �������� (A-Z)
 for i:=0 to High(M) do
 begin
    Write(c,' ');
    Inc(c);
    for j:=0 to High(M[i])-1 do //��������� ������� ������ ������ �� ���������
      Write(M[i,j]);
    Writeln;
 end;
end;

{dfs ����� ����}
function GetPath(const G:TMatrix; Src,Dst:integer):string;
var
 i,j:integer;
begin
 if (Src>High(G)) or (Dst>High(G)) then    //�������� ������
 begin
    Result:='';
    exit;
 end;
{���� � �������}
 Result:=chr(Src+ord('A')); //����������
 G[Src,High(G[Src])]:=1;    //��������� �����
 if Src=Dst then
    exit;
{����� ����, ������� �� ������� �������}
 for j:=0 to High(G[Src])-1 do
    if G[Src,j]=1 then            //������� �����
      for i:=0 to High(G) do       //����� ������� �������
        if (G[i,j]=1) and (G[i,High(G[i])]=0) then  //���� ������� ������� ��� �� ��������������,
          Result:=Result+GetPath(G,i,Dst);           //�� ��������� ���� � ��
 G[Src,High(G[Src])]:=0;
 if Result[Length(Result)]<>chr(Dst+ord('A')) then
    delete(Result,Length(Result),1);
end;


// �������� ���������
var
 M:TMatrix;
 c:char;
 NodeA,NodeB:integer;
 Path:string;
begin
 M:=LoadMatrix('Matrix.txt');
 PrintMatrix(M);
 if M<>nil then
 begin
    Writeln;
    Write(rus('��������� ������� (���������): '));
    Readln(c);
    NodeA:=ord(c)-ord('A');
    Write(rus('�������� ������� (���������): '));
    Readln(c);
    NodeB:=ord(c)-ord('A');
    Path:=GetPath(M,NodeA,NodeB);   //����� ����
    Write(rus('����: '));
    if Path<>'' then
      Writeln(Path)
    else
      Writeln(rus('���� �� ������!'));
 end;
 Readln;
end.
