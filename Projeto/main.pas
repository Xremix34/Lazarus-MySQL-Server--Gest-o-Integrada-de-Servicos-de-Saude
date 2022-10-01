unit Main;

{$mode objfpc}{$H+}

interface


uses
  Classes, SysUtils, mssqlconn, sqldb, db, Forms, Controls, Graphics, Dialogs,
  Menus, DBGrids, StdCtrls, ExtCtrls;

type

  { TfmMainForm }

  TfmMainForm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    DataSourceProf: TDataSource;
    DataSourceCurso: TDataSource;
    DataSourceAtrib: TDataSource;
    DataSourceDep: TDataSource;
    DBGridDep: TDBGrid;
    DBGridEmp: TDBGrid;
    DBGridProj: TDBGrid;
    DBGridAtrib: TDBGrid;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    laRefresh: TLabel;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem13: TMenuItem;
    MenuItem14: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MSSQLConnection: TMSSQLConnection;
    SQLQueryProf: TSQLQuery;
    SQLQueryCurso: TSQLQuery;
    SQLQueryAtrib: TSQLQuery;
    SQLQueryDep: TSQLQuery;
    SQLTransaction: TSQLTransaction;
    tmRefresh: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure DataSourceCursoDataChange(Sender: TObject; Field: TField);
    procedure DataSourceDepDataChange(Sender: TObject; Field: TField);
    procedure FormCreate(Sender: TObject);
    procedure laRefreshClick(Sender: TObject);
    procedure MenuItem10Click(Sender: TObject);
    procedure MenuItem12Click(Sender: TObject);
    procedure MenuItem13Click(Sender: TObject);
    procedure MenuItem14Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure MenuItem8Click(Sender: TObject);
    procedure MSSQLConnectionAfterConnect(Sender: TObject);
    procedure tmRefreshTimer(Sender: TObject);
    procedure ToggleBox1Change(Sender: TObject);
  private
    RefreshNVezes :Integer;
  public

  end;

var
  fmMainForm: TfmMainForm;

implementation

{$R *.lfm}

Uses Departamento, Professor, curso,
  consultarinscricao, Login, estudante;


{ TfmMainForm }

procedure TfmMainForm.MenuItem2Click(Sender: TObject);
begin
    close
end;

procedure TfmMainForm.MenuItem3Click(Sender: TObject);
begin

end;

procedure TfmMainForm.MenuItem4Click(Sender: TObject);
begin
    with TconsultEmp.Create(Nil) do
    try
      ShowModal;
    finally
      free
    end;
end;

procedure TfmMainForm.MenuItem6Click(Sender: TObject);
begin
  Button4Click(Sender)
end;

procedure TfmMainForm.MenuItem8Click(Sender: TObject);
begin
  Button3Click(Sender)
end;

procedure TfmMainForm.MSSQLConnectionAfterConnect(Sender: TObject);
begin

end;

procedure TfmMainForm.tmRefreshTimer(Sender: TObject);
  Const NSecs = 10;
begin
  RefreshNVezes := RefreshNVezes +1;
  laRefresh.Caption := 'Time to refresh: ' + IntToStr(NSecs - RefreshNVezes);

  if NSecs - RefreshNVezes  = 0 then
  begin
    RefreshNVezes := 0;
    SQLQueryDep.Refresh;
    SQLQueryProf.Refresh;
    SQLQueryCurso.Refresh;
    SQLQueryAtrib.Close;
    SQLQueryAtrib.Open;
  end;
end;

procedure TfmMainForm.ToggleBox1Change(Sender: TObject);
begin

end;

procedure TfmMainForm.FormCreate(Sender: TObject);
   var aHostName, aDatabase, aUserName, aPassword :String;
begin
  if not GetLoginData( aHostName, aDatabase, aUserName, aPassword) then
    Application.Terminate;   //Terminar a aplicação

  Try
    RefreshNVezes := 0;
    tmRefresh.Enabled := False;

    //Configurar o acesso à Base de Dados
    With MSSQLConnection do
    begin
      Connected := False;

      hostname := aHostName;
      username := aUserName;
      password := aPassword;

      Params.Clear;
      Params.Add('AutoCommit=true');
      Params.Add('TextSize=16777216');
      Params.Add('ApplicationName=EX1');
        // Connected := True;  // See below
    end;

    //Configurar o component SQLTransaction
     with SQLTransaction do
     begin
       if Active then
         Active := False;
       DataBase := MSSQLConnection;
     end;

     //Base de dados...
     MSSQLConnection.DatabaseName:= aDatabase;

     //Configurar o query
     with  SQLQueryDep do
     begin
       if Active then
         Close;
       DataBase := MSSQLConnection;
       Transaction := MSSQLConnection.Transaction;
       SQL.Clear;
       SQL.Add('Select * ');
       SQL.Add('From Departamento ');
       SQL.Add('Order by DepCod Desc');
       // Open;  // See below
     end;


     //Ligar o Dataset à grelha, via datasource
     DataSourceDep.DataSet := SQLQueryDep;
     DBGridDep.DataSource := DataSourceDep;

     //Para os empregados
     with  SQLQueryProf do
     begin
       if Active then
         Close;
       DataBase := MSSQLConnection;
       Transaction := MSSQLConnection.Transaction;
       Sql.Text:= 'Select * From Professor Order By ProfessorID';
    end;
    DataSourceProf.DataSet := SQLQueryProf;
    DBGridEmp.DataSource := DataSourceProf;


    //Para os Projectos
    with  SQLQueryCurso do
    begin
      if Active then
        Close;
      DataBase := MSSQLConnection;
      Transaction := MSSQLConnection.Transaction;
      Sql.Text:= 'Select * From Curso Order By ProfessorID';
   end;
   DataSourceCurso.DataSet := SQLQueryCurso;
   DBGridProj.DataSource := DataSourceCurso;

   //Para as Atribuições
   with  SQLQueryAtrib do
   begin
     if Active then
       Close;
     DataBase := MSSQLConnection;
     Transaction := MSSQLConnection.Transaction;
     Sql.Text:= 'Select * From Estudante Order By EstudanteID';
  end;
  DataSourceAtrib.DataSet := SQLQueryAtrib;
  DBGridAtrib.DataSource := DataSourceAtrib;


    //Aceder aos dados
    Try
      //1. Ligar ao servidor
      with MSSQLConnection do
      begin
        if Connected then
          Connected := False;
        Connected := True;
      end;

      //2. Activar a componente de transacções
      with SQLTransaction do
      begin
        if Active then
          Active := False;
        Active := True;
      end;

      MSSQLConnection.ExecuteDirect('Set Transaction isolation level read uncommitted');

      //3. Aceder aos dados Deps(executar o query)
      with SQLQueryDep do
      begin
        if Active then
          Close;
        Open;
      end;

      //4. Aceder aos dados Emps (executar o query)
      with SQLQueryProf do
      begin
        if Active then
          Close;
        Open;
      end;

      //5. Aceder aos dados Projs (executar o query)
      with SQLQueryCurso do
      begin
        if Active then
          Close;
        Open;
      end;

      //6. Aceder aos dados Atribs(executar o query)
      with SQLQueryAtrib do
      begin
        if Active then
          Close;
        Open;
      end;

    //Se alguma coisa funcionou mal...
    //... mostrar uma mensagem e...
    //... terminar a aplicação!
    Except
      on E:exception do
      begin
        ShowMessage(e.message);

        if MSSQLConnection.Connected then
          MSSQLConnection.Connected:= False;

        //Terminar a aplicação
        Application.Terminate;
      end;
    end;


  finally
    if MSSQLConnection.Connected Then
      tmRefresh.Enabled := True;
  end;
end;

procedure TfmMainForm.laRefreshClick(Sender: TObject);
begin

end;

procedure TfmMainForm.MenuItem10Click(Sender: TObject);
begin
{  with TAtrib.Create(Nil) do
    try
      ShowModal;
    finally
      free
    end;
}
end;


procedure TfmMainForm.MenuItem12Click(Sender: TObject);
begin
  Button1Click(Sender)
end;

procedure TfmMainForm.MenuItem13Click(Sender: TObject);
begin
  Button3Click(Sender)
end;

procedure TfmMainForm.MenuItem14Click(Sender: TObject);
begin
   Button4Click(Sender)
end;

procedure TfmMainForm.DataSourceDepDataChange(Sender: TObject; Field: TField);
begin

end;

procedure TfmMainForm.Button1Click(Sender: TObject);
begin
   with TfmDepartamento.Create(Nil) do
    try
      ShowModal;
    finally
      free
    end;

 end;

procedure TfmMainForm.Button2Click(Sender: TObject);
begin
  SQLQueryDep.Close;
  SQLQueryDep.Open


end;

procedure TfmMainForm.Button3Click(Sender: TObject);

begin
  with TEmp.Create(Nil) do
    try
      ShowModal;
    finally
      free
    end;
end;

procedure TfmMainForm.Button4Click(Sender: TObject);
begin
   with TFEstudante.Create(Nil) do
    try
      ShowModal;
    finally
      free
    end;
end;

procedure TfmMainForm.DataSourceCursoDataChange(Sender: TObject; Field: TField);
begin

end;

end.

