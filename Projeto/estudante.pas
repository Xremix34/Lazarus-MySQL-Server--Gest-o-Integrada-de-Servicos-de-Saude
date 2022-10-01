unit estudante;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb, db, mssqlconn, Forms, Controls, Graphics, Dialogs,
  StdCtrls;

type

  { TFEstudante }

  TFEstudante = class(TForm)
    Button1: TButton;
    Button2: TButton;
    DataSourceEstudante: TDataSource;
    edNomeEstudante: TEdit;
    edEndereco: TEdit;
    edEstudanteID: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    MSSQLConnectionEstudante: TMSSQLConnection;
    SQLQueryEstudante: TSQLQuery;
    SQLTransactionEstudante: TSQLTransaction;
    procedure Button2Click(Sender: TObject);
    procedure Label1Click(Sender: TObject);

  public

  end;

var
  FEstudante: TFEstudante;

implementation
uses Main;
{$R *.lfm}

{ TFEstudante }

procedure TFEstudante.Label1Click(Sender: TObject);
begin
   ModalResult := mrCancel
end;

procedure TFEstudante.Button2Click(Sender: TObject);
var stSQLText :String;
begin
   stSQLText := 'Insert into Estudante(NomeEst, Endereco, EstudanteID) values (:NomeEst, :Endereco, :EstudanteID)';
 SQLQueryEstudante.Sql.Text:= stSQLText;
 SQLQueryEstudante.Prepare;
 SQLQueryEstudante.ParamByName('NomeEst').AsString:= edNomeEstudante.Text;
 SQLQueryEstudante.ParamByName('Endereco').AsString:= edEndereco.Text;
 SQLQueryEstudante.ParamByName('EstudanteID').AsString:= edEstudanteID.Text;
 SQLQueryEstudante.ExecSQL;
 SQLQueryEstudante.SQLTransaction.Commit;
 ModalResult := mrOk

end;

end.

