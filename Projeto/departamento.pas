unit Departamento;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, mssqlconn, sqldb, Forms, Controls, Graphics, Dialogs,
  StdCtrls;

type

  { TfmDepartamento }

  TfmDepartamento = class(TForm)
    Button1: TButton;
    Button2: TButton;
    edCodDep: TEdit;
    edDepNome: TEdit;
    edChefeID: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    MSSQLConnectionDepartamento: TMSSQLConnection;
    SQLQueryDepartamento: TSQLQuery;
    SQLTransactionDepartamento: TSQLTransaction;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure edCodDepChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Label1Click(Sender: TObject);
  private

  public

  end;

var
  fmDepartamento: TfmDepartamento;

implementation

{$R *.lfm}

{ TfmDepartamento }

procedure TfmDepartamento.Label1Click(Sender: TObject);
begin

end;

procedure TfmDepartamento.Button2Click(Sender: TObject);
begin
  ModalResult := mrCancel
end;

procedure TfmDepartamento.edCodDepChange(Sender: TObject);
begin

end;

procedure TfmDepartamento.Button1Click(Sender: TObject);
var stSQLText :String;
begin
   stSQLText := 'Insert into Departamento(DepNome, Depcod, ChefeID) values (:DepNome, :Depcod, :ChefeID)';
 SQLQueryDepartamento.Sql.Text:= stSQLText;
 SQLQueryDepartamento.Prepare;
 SQLQueryDepartamento.ParamByName('DepNome').AsString:= edCodDep.Text;
 SQLQueryDepartamento.ParamByName('Depcod').AsString:= edDepNome.Text;
 SQLQueryDepartamento.ParamByName('ChefeID').AsString:= edChefeID.Text;
 SQLQueryDepartamento.ExecSQL;
 SQLQueryDepartamento.SQLTransaction.Commit;
 ModalResult := mrOk

end;

procedure TfmDepartamento.FormCreate(Sender: TObject);
begin

end;

end.

