unit Professor;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, mssqlconn, sqldb, Forms, Controls, Graphics,
  Dialogs, StdCtrls, DBCtrls;

type

  { TEmp }

  TEmp = class(TForm)
    ButtonInserir: TButton;
    cbDepCod: TDBComboBox;
    edEmpNum: TEdit;
    edNome: TEdit;
    edCategoria: TEdit;
    edTelefone: TEdit;
    edGabinete: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    procedure ButtonInserirClick(Sender: TObject);
    procedure cbDepCodChange(Sender: TObject);
    procedure edCategoriaChange(Sender: TObject);
    procedure edTelefoneChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure Label4Click(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
  private

  public

  end;

var
  Emp: TEmp;

implementation

uses Main;

{$R *.lfm}

{ TEmp }

procedure TEmp.Label4Click(Sender: TObject);
begin

end;

procedure TEmp.StaticText1Click(Sender: TObject);
begin

end;

procedure TEmp.ButtonInserirClick(Sender: TObject);
   var stSQLText :String;
begin
  //Não há Departamentos, nada a fazer!
  if cbDepCod.Items.Count = 0 then
    Exit;

  with TSQLQuery.Create(Nil) do
  Try
    Try
      DataBase := fmMainform.MSSQLConnection;
      Transaction := fmMainform.MSSQLConnection.Transaction;

      //Prepara o SQL a submeter à BD
      stSQLText := 'Insert into Professor(ProfessorID, Nome, Salario, Telefone, Gabinete, DepCod) ';
      stSQLText := stSQLText + '  values (:ProfessorID, :Nome, :Salario, :Telefone, :Gabinete, :DepCod)';

      //Set do comando SQL para inserir um empregado
      Sql.Text:= stSQLText;

      SQLTransaction.StartTransaction;
      Prepare;
      ParamByName('ProfessorID').AsString:= edEmpNum.Text;
      ParamByName('Nome').AsString:= edNome.Text;
      ParamByName('Salario').AsString:= edTelefone.Text;
      ParamByName('Telefone').AsString:= edTelefone.Text;
      ParamByName('Gabinete').AsString:= edGabinete.Text;
      ParamByName('DepCod').AsString:= cbDepCod.Items[cbDepCod.ItemIndex];

      //Insere na base de dados
      ExecSQL;

      SQLTransaction.Commit;

      //Fecha o diálogo!
      ModalResult := mrOk;

    Except
      On E :Exception do
      begin
        //Faz o Roolback da transação (e volta ao modo Auto-Commit)
        SQLTransaction.Rollback;
        ShowMessage(E.Message);
      end;
    end;

  finally
    Free;
  end;
end;

procedure TEmp.cbDepCodChange(Sender: TObject);
begin

end;

procedure TEmp.edCategoriaChange(Sender: TObject);
begin

end;

procedure TEmp.edTelefoneChange(Sender: TObject);
begin

end;
procedure TEmp.Label2Click(Sender: TObject);
begin

end;
procedure TEmp.FormCreate(Sender: TObject);
begin
  //Criar e Configurar um query
  with TSQLQuery.Create(Nil) do
  Try
    Try
      DataBase := fmMainform.MSSQLConnection;
      Transaction := fmMainform.MSSQLConnection.Transaction;
      SQL.Clear;
      SQL.Add('Select * From Departamento Order By DepCod');

      //Ir buscar os dados
      Open;

      //Preencher a combobox com o número de departamento
      while not eof do
      begin
        cbDepCod.items.add(fieldbyname('DepCod').AsString);
        next;
      end;

      //Colocar o primeiro elemento da lista como ativo...
      if cbDepCod.Items.Count > 0 then
        cbDepCod.ItemIndex:= 0 ;
    Finally
      if Active then
        Close;
      Free;
    end;
  //Se alguma coisa funcionou mal...
  //... mostrar uma mensagem e...
  Except
    on E:exception do
    begin
      ShowMessage(e.message);
    end;
  end;
end;



end.

