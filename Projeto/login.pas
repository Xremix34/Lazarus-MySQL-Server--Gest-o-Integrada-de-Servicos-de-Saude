unit Login;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { Tuserlogin }

  Tuserlogin = class(TForm)
    btnlogin: TButton;
    btncancel: TButton;
    hostname: TEdit;
    databasename: TEdit;
    ip: TLabel;
    username: TEdit;
    password: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    procedure btnloginClick(Sender: TObject);
    procedure btncancelClick(Sender: TObject);
    procedure databasenameChange(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure ipClick(Sender: TObject);
  private

  public

  end;


var
  userlogin: Tuserlogin;

Function GetLoginData(var aHostName, aDatabase, aUserName, aPassword :String):Boolean;


implementation

{$R *.lfm}


 Uses Winsock;


  Function GetLoginData(var aHostName, aDatabase, aUserName, aPassword :String):Boolean;
  begin
    //Inicializar os parâmetros
    Result    := False;

    aHostName := '';
    aDatabase := '';
    aUserName := '';
    aPassword := '';

    Try
      With  Tuserlogin.Create(Nil) do
      Try
        Result := ShowModal = mrOk;
        if Result then
        begin
          aHostName := hostname.TextHint;
          aDatabase := databasename.TextHint;
          aUserName := username.TextHint;
          aPassword := password.TextHint;
        end
      finally
        Free
      end;
    except
      Result := False
    end;
  end;


  // How to get you local IP address in Windows with Pascal:
  // https://afuriza.wordpress.com/2016/01/27/how-to-get-you-local-ip-address-in-windows-with-pascal/
  function getlocalip:string;
  type
    TaPInAddr = array [0..10] of PInAddr;
    PaPInAddr = ^TaPInAddr;
  var
    phe : PHostEnt;
    pptr : PaPInAddr;
    buffer : array [0..63] of char;
    i : integer;
    GInitData : TWSADATA;
  begin
    WSAStartup($101, GInitData);
    Result:='';
    GetHostName(buffer, sizeof(buffer));
    phe:=gethostbyname(buffer);
    if phe = nil then
    begin
      Exit;
    end;
    pptr:= PaPInAddr(phe^.h_addr_list);
    i:=0;
    while not (pptr^[i] = nil) do
    begin
      result:=StrPas(inet_ntoa(pptr^[i]^));
      Inc(i);
    end;
    WSACleanup;
  end;





{ Tuserlogin }

procedure Tuserlogin.Label2Click(Sender: TObject);
begin

end;

procedure Tuserlogin.ipClick(Sender: TObject);
begin
   ip.Caption:= 'My IP: '+ getlocalip;
end;

procedure Tuserlogin.databasenameChange(Sender: TObject);
begin

end;

procedure Tuserlogin.btnloginClick(Sender: TObject);
begin
   ModalResult := mrOk
end;

procedure Tuserlogin.btncancelClick(Sender: TObject);
begin
     ModalResult := mrCancel
end;

end.

