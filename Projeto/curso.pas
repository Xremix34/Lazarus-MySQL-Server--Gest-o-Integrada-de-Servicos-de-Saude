unit curso;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, mssqlconn, sqldb, Forms, Controls, Graphics, Dialogs,
  StdCtrls;

type

  { TProj }

  TProj = class(TForm)
    Button1: TButton;
    Button2: TButton;
    edHorario: TEdit;
    edIDProfessor: TEdit;
    edCurso: TEdit;
    edDepCod: TEdit;
    edNomeCurso: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    MSSQLConnection1: TMSSQLConnection;
    SQLQuery1: TSQLQuery;
    SQLTransaction1: TSQLTransaction;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure MSSQLConnection1AfterConnect(Sender: TObject);
  private

  public

  end;

var
  Proj: TProj;

implementation

{$R *.lfm}

{ TProj }

procedure TProj.Label2Click(Sender: TObject);
begin

end;

procedure TProj.MSSQLConnection1AfterConnect(Sender: TObject);
begin

end;

procedure TProj.Button1Click(Sender: TObject);
   var stSQLText :String;
begin
     stSQLText := 'Insert into Curso(CursoID, DepCod, NomeCurso, horario, IDProfessor) values (:CursoID, :DepCod, :NomeCurso, :horario, :IDProfessor)';
 SQLQuery1.Sql.Text:= stSQLText;
 SQLQuery1.Prepare;
 SQLQuery1.ParamByName('CursoID').AsString:= edCurso.Text;
 SQLQuery1.ParamByName('Depcod').AsString:= edDepCod.Text;
 SQLQuery1.ParamByName('NomeCurso').AsString:= edNomeCurso.Text;
  SQLQuery1.ParamByName('Horario').AsString:= edDepCod.Text;
 SQLQuery1.ParamByName('IDProfessor').AsString:= edNomeCurso.Text;
 SQLQuery1.ExecSQL;
 SQLQuery1.SQLTransaction.Commit;
 ModalResult := mrOk
end;

procedure TProj.Button2Click(Sender: TObject);
begin
  Close
end;

procedure TProj.CheckBox1Change(Sender: TObject);
begin

end;

end.

