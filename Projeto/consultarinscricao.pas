unit consultarinscricao;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, mssqlconn, sqldb, db, Forms, Controls, Graphics, Dialogs,
  DBGrids, StdCtrls, ExtCtrls, Professor, estudante;

type

  { TconsultEmp }

  TconsultEmp = class(TForm)
    inserir: TButton;
    alterar: TButton;
    eliminar: TButton;
    DataSourceInscreve: TDataSource;
    DBGrid1: TDBGrid;
    Label1: TLabel;
    Label2: TLabel;
    laRefresh: TLabel;
    MSSQLConnection: TMSSQLConnection;
    SQLQueryInscreve: TSQLQuery;
    SQLTransactionInscreve: TSQLTransaction;
    tmRefreshInscricao: TTimer;
    procedure alterarClick(Sender: TObject);
    procedure eliminarClick(Sender: TObject);
    procedure inserirClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure tmRefreshInscricaoTimer(Sender: TObject);
    private
    RefreshNVezes :Integer;

  public

  end;

var
  consultEmp: TconsultEmp;

implementation

uses Main;

{$R *.lfm}

{ TconsultEmp }

procedure TconsultEmp.FormCreate(Sender: TObject);
begin

end;

procedure TconsultEmp.tmRefreshInscricaoTimer(Sender: TObject);
Const NSecs = 10;
begin
  RefreshNVezes := RefreshNVezes +1;
  laRefresh.Caption := 'Time to refresh: ' + IntToStr(NSecs - RefreshNVezes);

  if NSecs - RefreshNVezes  = 0 then
  begin
    RefreshNVezes := 0;
    SQLQueryInscreve.Refresh;
  end;
 end;
procedure TconsultEmp.inserirClick(Sender: TObject);
begin
         with TFEstudante.Create(Nil) do
    try
      ShowModal;
    finally
      free
    end;
end;

procedure TconsultEmp.eliminarClick(Sender: TObject);
var stEmpNum:String;
begin
  if not SQLQueryInscreve.Active Then
    Exit;

  Try
    //Desativar o timer
    tmRefreshInscricao.Enabled := False;

    If MessageDlg('Apagar...',
        'Pretende apagar a inscrição do Aluno: ' + SQLQueryInscreve.FieldByName('EstudanteID').AsString
      + ' ' + SQLQueryInscreve.FieldByName('CursoID').AsString,
      mtConfirmation, [mbYes,mbNo],0) = mrYes then

      With TSQLQuery.Create(Nil) do
      Try
        Try
          DataBase := MSSQLConnection;
          Transaction := MSSQLConnection.Transaction;

          SQL.Text := 'Delete From Inscreve Where EstudanteID =' + SQLQueryInscreve.FieldByName('EstudanteID').AsString;

          MSSQLConnection.StartTransaction;
          //Apagar projecto corrente
          ExecSQL;
          SQLTransactionInscreve.Commit;
        except
          On e:exception do
          begin
            //Houve um problema... Desfazer!
            SQLTransactionInscreve.Rollback;
            ShowMessage(E.Message);
          end;
        end;
      finally
        Free
      end;
  finally
    //activar o timer
    tmRefreshInscricao.Enabled := True;
  end;

end;

procedure TconsultEmp.alterarClick(Sender: TObject);
 begin



end;


end.

