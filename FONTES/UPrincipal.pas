unit UPrincipal;

interface

uses
     Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
     Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons,
     dxGDIPlusClasses, Vcl.ExtCtrls, Vcl.StdCtrls, Math, Data.DB;

type
     TfrmPrincipal   =  class(TForm)
          pnmenu: TPanel;
          gb_preco: TGroupBox;
          Label1: TLabel;
          Label2: TLabel;
          edt_qtdsand: TEdit;
          edt_qtdsuco: TEdit;
          Label3: TLabel;
          edt_valorpago: TEdit;
          Label4: TLabel;
          lbl_total: TLabel;
          lbl_troco: TLabel;
          Label7: TLabel;
          btn_receber: TSpeedButton;
          edt_precosanduiche: TEdit;
          edt_precosuco: TEdit;
          Label12: TLabel;
          Label13: TLabel;
          btn_calcular: TSpeedButton;
          GroupBox1: TGroupBox;
          Image8: TImage;
          lbl_m25: TLabel;
          Image9: TImage;
          lbl_m10: TLabel;
          lbl_m50: TLabel;
          Image10: TImage;
          lbl_m5: TLabel;
          Image11: TImage;
          Image12: TImage;
          lbl_m1: TLabel;
          GroupBox2: TGroupBox;
          Image1: TImage;
          lbl_qtd1: TLabel;
          lbl_qtd2: TLabel;
          Image2: TImage;
          lbl_qtd5: TLabel;
          Image3: TImage;
          lbl_qtd10: TLabel;
          Image6: TImage;
          Image7: TImage;
          lbl_qtd20: TLabel;
          Image5: TImage;
          lbl_qtd50: TLabel;
          Image4: TImage;
          lbl_qtd100: TLabel;
          btn_sair: TSpeedButton;
          btn_novavenda: TSpeedButton;
          Label5: TLabel;
          procedure FormShow(Sender: TObject);
          procedure btn_calcularClick(Sender: TObject);
          procedure btn_receberClick(Sender: TObject);
          procedure btn_sairClick(Sender: TObject);
          procedure FormClose(Sender: TObject; var Action: TCloseAction);
          procedure btn_novavendaClick(Sender: TObject);
          procedure edt_qtdsandKeyPress(Sender: TObject; var Key: Char);
     private
    { Private declarations }
          function limparTroco(ch: string): string;
     public
    { Public declarations }
     end;

var
     frmPrincipal: TfrmPrincipal;
     sanduiche, suco, valorTotal, valorTroco: Double;
     calc: string;

implementation

{$R *.dfm}

procedure TfrmPrincipal.btn_receberClick(Sender: TObject);
const
     nota: array[1..7] of integer = (100, 50, 20, 10, 5, 2, 1);
     centavos: array[1..5] of integer = (50, 25, 10, 5, 1);
var
     valorReceber, trocoNota, trocoMoeda: Double;
     i, qtdNotas, qtdMoedas: Integer;
     qtdNotasArray: array[1..7] of Integer;
     qtdCentavosArray: array[1..5] of Integer;
begin
     //VALIDAÇÕES
     if edt_valorpago.Text   =  '' then
     begin
          Application.MessageBox('Preencha o valor pago pelo cliente!', 'ERRO', MB_OK   +  MB_ICONSTOP);
          Exit
     end;

     valorReceber   :=  StrToFloat(edt_valorpago.Text);

     if valorTotal   >  valorReceber then
     begin
          Application.MessageBox('O valor recebido é menor que o valor total!', 'ERRO', MB_OK   +  MB_ICONSTOP);
          Exit
     end;

     try
          //INSERIR VALORES NO ARRAY NOTA PARA ATRIBUIÇÕES NO WHILE LOGO ABAIXO
          qtdNotasArray[1]   :=  0;
          qtdNotasArray[2]   :=  0;
          qtdNotasArray[3]   :=  0;
          qtdNotasArray[4]   :=  0;
          qtdNotasArray[5]   :=  0;
          qtdNotasArray[6]   :=  0;
          qtdNotasArray[7]   :=  0;

          //INSERIR VALORES NO ARRAY MOEDAS PARA ATRIBUIÇÕES NO WHILE LOGO ABAIXO
          qtdCentavosArray[1]   :=  0;
          qtdCentavosArray[2]   :=  0;
          qtdCentavosArray[3]   :=  0;
          qtdCentavosArray[4]   :=  0;
          qtdCentavosArray[5]   :=  0;

          //GERAR O RESULTADO DO TROCO
          valorTroco   :=  valorReceber   -  valorTotal;
          lbl_troco.Caption   :=  FloatToStr(RoundTo(valorTroco, -2));

          //DIVIDIR A PARTE DO TROCO PARA PEGAR A QUANTIDADE DE NOTAS
          i   :=  1;
          trocoNota   :=  Trunc(valorTroco);
          while (trocoNota   <>  0) do  //ENQUANTO TROCO NOTA FOR DIFERENTE DE 0
          begin
               qtdNotas   :=  Trunc(trocoNota)   div  nota[i]; // CALCULA A QUANTIDADE DE NOTA POSSIVEIS
               if (qtdNotas   <>  0) then   //SE QTD NOTAS FOR DIFERENTE DE 0
               begin
                    qtdNotasArray[i]   :=  qtdNotas; //ADD O NUMERO DE NOTAS NO ARRAY NOTAS
                    trocoNota   :=  Trunc(trocoNota)   mod  nota[i]; // SOBRA DO TROCO
               end;
               i   :=  i   +  1; // PROXIMO VALOR
          end;

          //ATRIBUIR PARA AS LABELS A QUANTIDADE DAS NOTAS
          lbl_qtd1.Caption   :=  IntToStr(qtdNotasArray[7])   +  ' x ';
          lbl_qtd2.Caption   :=  IntToStr(qtdNotasArray[6])   +  ' x ';
          lbl_qtd5.Caption   :=  IntToStr(qtdNotasArray[5])   +  ' x ';
          lbl_qtd10.Caption   :=  IntToStr(qtdNotasArray[4])   +  ' x ';
          lbl_qtd20.Caption   :=  IntToStr(qtdNotasArray[3])   +  ' x ';
          lbl_qtd50.Caption   :=  IntToStr(qtdNotasArray[2])   +  ' x ';
          lbl_qtd100.Caption   :=  IntToStr(qtdNotasArray[1])   +  ' x ';


          //MESMO PROCEDIMENTO DAS NOTAS SÓ QUE FRACIONAR O TROCO PARA PEGAR SÓ OS NUMEROS DECIMAIS
          trocoMoeda   :=  round(frac(valorTroco)   *  100);
          i   :=  1;

          while (trocoMoeda   <>  0) do
          begin
               qtdMoedas   :=  Trunc(trocoMoeda)   div  centavos[i]; // calculando a qtde de moedas
               if (qtdMoedas   <>  0) then
               begin
                    qtdCentavosArray[i]   :=  qtdMoedas;
                    trocoMoeda   :=  Trunc(trocoMoeda)   mod  centavos[i]; // sobra
               end;
               i   :=  i   +  1; // próxima moeda
          end;

          //ATRIBUIR PARA AS LABELS A QUANTIDADE DAS MOEDAS
          lbl_m1.Caption   :=  IntToStr(qtdCentavosArray[5])   +  ' x ';
          lbl_m5.Caption   :=  IntToStr(qtdCentavosArray[4])   +  ' x ';
          lbl_m10.Caption   :=  IntToStr(qtdCentavosArray[3])   +  ' x ';
          lbl_m25.Caption   :=  IntToStr(qtdCentavosArray[2])   +  ' x ';
          lbl_m50.Caption   :=  IntToStr(qtdCentavosArray[1])   +  ' x ';

          limparTroco('2'); //FUNÇÃO PARA TORNAR OS LABELS VISIVEIS
     except
          on E: Exception do
          begin
               ShowMessage(' Erro = '   +  E.Message);   //SE DER ERRO APRESENTAR A MSG
          end;
     end;

end;

procedure TfrmPrincipal.btn_sairClick(Sender: TObject);
begin
     if Application.MessageBox('Deseja sair do programa?', 'Sair', MB_YESNO   +  MB_ICONQUESTION)   =  IDYES then
     begin
          Close;
     end;
end;

procedure TfrmPrincipal.edt_qtdsandKeyPress(Sender: TObject; var Key: Char);
begin
     //VALIDAÇÃO PARA NÃO ENTRAR LETRAS NO EDT
     if not (Key   in  ['0'..'9', ',', #8]) then
     begin
          Key   :=  #0;
          Application.MessageBox('Somente numeros e virgula se for numero decimal por favor!', 'ERROR', MB_OK   +  MB_ICONSTOP);
     end;
end;

procedure TfrmPrincipal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
     Application.Terminate;
end;

procedure TfrmPrincipal.FormShow(Sender: TObject);
begin
      //ATRIBUIR O VALOR FIXO DOS PRODUTOS EM VARIAVEIS GLOBAIS
     sanduiche   :=  StrToFloat(edt_precosanduiche.Text);
     suco   :=  StrToFloat(edt_precosuco.Text);
     edt_qtdsand.SetFocus;

end;

function TfrmPrincipal.limparTroco(ch: string): string;
begin
//FUNÇÃO PARA TORNAR AS LBLS DO TROCO VISIVEL OU INVISIVEL
     if ch   =  '1' then
     begin
          lbl_qtd1.Visible   :=  False;
          lbl_qtd2.Visible   :=  False;
          lbl_qtd5.Visible   :=  False;
          lbl_qtd10.Visible   :=  False;
          lbl_qtd20.Visible   :=  False;
          lbl_qtd50.Visible   :=  False;
          lbl_qtd100.Visible   :=  False;
          lbl_m1.Visible   :=  False;
          lbl_m5.Visible   :=  False;
          lbl_m10.Visible   :=  False;
          lbl_m25.Visible   :=  False;
          lbl_m50.Visible   :=  False;
          edt_qtdsand.Text   :=  '0';
          edt_qtdsuco.Text   :=  '0';
          edt_valorpago.Text   :=  '0';
          lbl_total.Caption   :=  '0,00';
          lbl_troco.Caption   :=  '0,00';
     end;
     if ch   =  '2' then
     begin
          lbl_qtd1.Visible   :=  True;
          lbl_qtd2.Visible   :=  True;
          lbl_qtd5.Visible   :=  True;
          lbl_qtd10.Visible   :=  True;
          lbl_qtd20.Visible   :=  True;
          lbl_qtd50.Visible   :=  True;
          lbl_qtd100.Visible   :=  True;
          lbl_m1.Visible   :=  True;
          lbl_m5.Visible   :=  True;
          lbl_m10.Visible   :=  True;
          lbl_m25.Visible   :=  True;
          lbl_m50.Visible   :=  True;
     end;
end;

procedure TfrmPrincipal.btn_novavendaClick(Sender: TObject);
begin
     //NOVA VENDA
     limparTroco('1');
     edt_valorpago.Enabled   :=  False;
     edt_qtdsand.SetFocus;
end;

procedure TfrmPrincipal.btn_calcularClick(Sender: TObject);
var
     qtdsand, qtdsuco: Integer;
begin
     //ATUALIZA O VALOR DAS VARIAVEIS CASO O USUARIO MODIFIQUE O PREÇO
     FormShow(Self);

     //VALIDAÇÃO PARA QUE OS VALORES DAS QUANTIDADES NÃO FIQUE VAZIO
     if (edt_qtdsand.Text   =  '')   or  (edt_qtdsuco.Text   =  '') then
     begin
          Application.MessageBox('Preencha a quantidade de itens do suco ou sanduiche que o cliente vai comprar.', 'ERRO', MB_OK   +  MB_ICONSTOP);
          Exit
     end;

     qtdsand   :=  StrToInt(edt_qtdsand.Text);
     qtdsuco   :=  StrToInt(edt_qtdsuco.Text);

     //VALOR TOTAL DA COMPRA QUANDO CLICAR EM CALCULAR
     valorTotal   :=  sanduiche   *  qtdsand   +  suco   *  qtdsuco;

     lbl_total.Caption   :=  FloatToStr(RoundTo(valorTotal, -2));

     //HABILITA O CAMPO VALOR RECEBIDO PARA QUE SEJA PREENCHIDO O VALOR
     edt_valorpago.Enabled   :=  True;
end;

end.

