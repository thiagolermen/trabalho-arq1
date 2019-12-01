;****************************************************
;				TRABALHO INTEL X86
;****************************************************

;Aluno: Thiago Sotoriva Lermen		Cartão: 00313020
;Professor: Sergio Luis Cechin
;Arquitetura e Organizacao de Computacores I

;****************************************************
;						ABSTRACT

; Ler arquivo com informacoes sobre paredes compostas
;por ladrilhos coloridos, exibindo as paredes na tela 
;(modo grafico e 16 cores). Exibir legenda com os
;totais de ladrilhos de cada cor encontrados e gravar
;arquivos ocm os totais por cor.
;-
;ETAPA 1
;	# MODO TEXTO (25 LINHAS DE 80 CARACTERES E 16 CORES)
;	# Chamar funcao LIMPATELA
;	# Identificacao (Nome: .... Cartao: .... CR LF)

;ETAPA 2
;	# Ler nome do arquivo texto que ocntem as informacoes
;sobre a cor dos ladrilhos e da parede de coordenadas
;iniciais e das movimentacoes.
;	# Na leitura do nome da parede deve ser tratado o caso
;de BACKSPACE (08h). 
;	# Quando o usuario digitar ENTER(0Dh), a digitacao do
;nome do arquivo terminou (o usuario podera informar
;o nome do arquivo com nome+sufixo ou apenas nome, logo
;deve-se tratar o caso adicionando ".PAR" no final).
;	# Se o usuario digitar apenas ENTER exibir mensagem de 
;encerramento do programa
;	# Após ler o nome do arquivo, abrir o arquivo
;(se nao ocorrer erro abrir tambem o arquivo de saida),
;limpar a tela e continuar

;ETAPA 3
;	# MODO GRAFICO (480 LINHAS E 650 COLUNAS COM 16 CORES)

;ETAPA 4
;	# Ler a primeira linha di arquivo, onde estarao informadas
;a altura e a largura da parede em ladrilhos. A altura maxima 
;sera 15 e a largura maxima 16 (informados como dois inteiros 
;sem sinal separados por uma virgula)
;	#Por ex:
;		5, 10 CR(0Dh) LF(0Ah)

;ETAPA 5
;	# Ler as demais linahs do arquivo, uma linha para cada
;linha de ladrilhos. Cada linha estarao as cores dos ladrilhos
;(sem separadores)
;	# Por ex:
;		0123456789 CR LF
;		ABCDE01234 CR LF
;		56789ABCDE CR LF
;		0123456789 CR LF
;		ABCDE01234 CR LF



;****************************************************
;				PROGRAMA PRINCIPAL
;****************************************************

	.model small
	.stack
		
CR				equ		13
LF				equ		10

		
	.data
	
	FileNameSrc		db		256 dup (?)		; Nome do arquivo a ser lido
	FileNameDst		db		256 dup (?)		; Nome do arquivo a ser escrito
	FileHandleSrc	dw		0				; Handler do arquivo origem
	FileHandleDst	dw		0				; Handler do arquivo destino
	FileBuffer		db		10 dup (?)		; Buffer de leitura/escrita do arquivo
	
	sw_n	dw	0
	sw_f	db	0
	sw_m	dw	0

	MsgPedeArquivoSrc	db	"Nome do arquivo origem: ", 0
	MsgPedeArquivoDst	db	"Nome do arquivo destino: ", 0
	MsgErroOpenFile		db	"Erro na abertura do arquivo.", CR, LF, 0
	MsgErroCreateFile	db	"Erro na criacao do arquivo.", CR, LF, 0
	MsgErroReadFile		db	"Erro na leitura do arquivo.", CR, LF, 0
	MsgErroWriteFile	db	"Erro na escrita do arquivo.", CR, LF, 0
	MsgCRLF				db	CR, LF, 0
	MsgCRLF2			db	CR, LF
	identificacao		db	"Nome: Thiago Cartao: 00313020",CR,LF,0
	msgFimExec			db	"Fim da execucao!",CR,LF,0
	msgAutor			db	"**********   Autor: Thiago Sotoriva Lermen ***** Cartao: 00313020   **********", 0
	msgRodape1			db	"Arquivo", 0
	msgRodape2			db	" - Total de ladrilhos por cor:", 0
	
	PRETO				dw		0
	AZUL				dw		0
	VERDE				dw		0
	CIANO				dw		0
	VERMELHO 			dw		0
	MAGENTA				dw		0
	MARROM				dw		0
	CINZA_CLARO			dw		0
	CINZA_ESCURO		dw		0
	AZUL_CLARO			dw		0
	VERDE_CLARO			dw		0
	CIANO_CLARO			dw 		0
	VERMELHO_CLARO		dw 		0
	MAGENTA_CLARO		dw		0
	AMARELO				dw		0
	BRANCO				dw		0
	
	stringPreto			db	"Preto - ", 0
	tamPreto			equ	8
	stringAzul			db	"Azul - ", 0
	tamAzul				equ	7
	stringVerde			db	"Verde - ", 0
	tamVerde			equ	8
	stringCiano			db	"Ciano - ", 0
	tamCiano			equ	8
	stringVermelho		db	"Vermelho - ", 0
	tamVermelho			equ	11
	stringMagenta		db	"Magenta - ", 0
	tamMagenta			equ	10
	stringMarrom		db	"Marrom - ", 0
	tamMarrom			equ	9
	stringCinzaClaro	db	"Cinza Claro - ", 0
	tamCinzaClaro		equ	14
	stringCinzaEscuro	db	"Cinza Escuro - ", 0
	tamCinzaEscuro		equ	15
	stringAzulClaro		db	"Azul Claro - ", 0
	tamAzulClaro		equ	13
	stringVerdeClaro	db	"Verde Claro - ", 0
	tamVerdeClaro		equ	14
	stringCianoClaro	db	"Ciano Claro - ", 0
	tamCianoClaro		equ	14
	stringVermelhoClaro	db	"Vermelho Claro - ", 0
	tamVermelhoClaro	equ	17
	stringMagentaClaro	db	"Magenta Claro - ", 0
	tamMagentaClaro		equ	16
	stringAmarelo		db	"Amarelo - ", 0
	tamAmarelo			equ	10
	stringBranco		db	"Branco - ", 0
	tamBranco			equ	9
	
	MAXSTRING	equ		200
	String		db		MAXSTRING dup (?)		; Usado na funcao gets
	numCor		db		10 	  	  dup (?)
	CONSTX		equ		10
	CONSTY		equ		25
	
	alturaArquivo	dw	0
	baseArquivo		dw 	0
	baseAux			dw	0
	alturaAux		dw	0
	linhaLida		dw 	0
	tamStringNum	dw	0
	aux				dw	0
	auxY			dw	0
	auxX			dw	0
	ladoLadrilho 	dw	0
	flagBaseJanela	dw	0
	flagAlturaJanela	dw	0
	posX			dw	0
	posY			dw	0
	posCursorX		db  0
	posCursorY		db 	0
	cor				db	0
	flagLado		dw	0
	linhaAtual		dw	0
	colunaAtual		dw	0
	flagPintaAltura	dw	0
	flagPintaLargura	dw	0
	constMaior		dw	0
	constAltura		dw 	0
	constBase		dw 	0
	.code
	.startup
	
	;Inicializa as variaveis
	mov		linhaLida, 0
	mov		alturaArquivo, 0
	mov		baseArquivo, 0
	mov		auxY, 0
	mov 	auxX, 0
	mov		cor, 0
	mov		alturaAux, 0
	mov		linhaLida, 0
	mov		tamStringNum, 0
	mov		ladoLadrilho, 0
	mov		flagBaseJanela, 0
	mov		flagAlturaJanela, 0
	mov		posX, 0
	mov		posY, 0
	mov		posCursorX, 0
	mov		posCursorY,	0
	mov		flagLado, 0
	mov		linhaAtual, 0
	mov		colunaAtual, 0
	mov		PRETO, 0
	mov		AZUL, 0
	mov		VERMELHO, 0
	mov		MAGENTA, 0
	mov		MARROM, 0
	mov		CINZA_CLARO, 0
	mov		AZUL_CLARO, 0
	mov		CIANO_CLARO, 0
	mov		VERMELHO_CLARO, 0
	mov		MAGENTA_CLARO, 0
	mov		AMARELO, 0
	mov		CINZA_ESCURO, 0
	mov		AZUL_CLARO, 0
	mov		VERDE, 0
	mov		CIANO, 0
	mov		VERDE_CLARO, 0
	mov		flagPintaAltura, 0
	mov		flagPintaLargura, 0
	mov		constMaior, 0
	mov		constBase, 0
	mov		constAltura, 0
	
	
	
	;Chama a funcao para alterar o modo grafico para texto
	call	modo_texto
	;Limpa a tela
	call	clrscr
	
	; printf("Nome: Thiago Cartao: 00313020\r\n")
	lea		BX, identificacao
	call	printf_s
	
	;Funcao para ler do arquivo
	call	fread

	
	

Final:		
	.exit
	
;****************************************************
;					MODO TEXTO
;****************************************************
modo_texto	proc	near
	
	push	ax
	
	mov		ah, 0
	mov		al, 07h
	int		10h
	
	pop	ax
	
	ret

modo_texto	endp

;****************************************************
;					MODO_GRAFICO
;****************************************************
modo_grafico	proc	near
	
	push	ax
	
	mov		ah, 0
	mov		al, 12h
	int		10h
	
	pop		ax
	ret

modo_grafico	endp

;****************************************************
;					LIMPA TELA
;****************************************************
clrscr	proc	near		
	
	;salva AX na pilha
	push 	AX
	 
	mov 	ah, 0h
	mov 	al, 3h
	int 	10h
	
	pop 	AX
	
	ret
		
		
clrscr	endp




;****************************************************
;					FREAD
;****************************************************
fread	proc	near

	

read:	

	mov		linhaLida, 0
	mov		alturaArquivo, 0
	mov		baseArquivo, 0
	mov		auxY, 0
	mov 	auxX, 0
	mov		cor, 0
	mov		alturaAux, 0
	mov		linhaLida, 0
	mov		tamStringNum, 0
	mov		ladoLadrilho, 0
	mov		flagBaseJanela, 0
	mov		flagAlturaJanela, 0
	mov		posX, 0
	mov		posY, 0
	mov		posCursorX, 0
	mov		posCursorY,	0
	mov		flagLado, 0
	mov		linhaAtual, 0
	mov		colunaAtual, 0
	mov		PRETO, 0
	mov		AZUL, 0
	mov		VERMELHO, 0
	mov		MAGENTA, 0
	mov		MARROM, 0
	mov		CINZA_CLARO, 0
	mov		AZUL_CLARO, 0
	mov		CIANO_CLARO, 0
	mov		VERMELHO_CLARO, 0
	mov		MAGENTA_CLARO, 0
	mov		AMARELO, 0
	mov		CINZA_ESCURO, 0
	mov		AZUL_CLARO, 0
	mov		VERDE, 0
	mov		CIANO, 0
	mov		VERDE_CLARO, 0
	mov		flagPintaAltura, 0
	mov		flagPintaLargura, 0
	mov		constMaior, 0
	
	call	kbhit				;Aguarda o usuario digitar uma tecla para boltar para o loop
	cmp		al, 0
	
	je 		read
	
	call 	clrbuff
	
	call	clrscr
	
	; printf("Nome: Thiago Cartao: 00313020\r\n")
	lea		BX, identificacao
	call	printf_s
	
	lea		bx,  fileNameSrc
	mov		[bx], 0
	lea		bx,  fileNameDst
	mov		[bx], 0
	
	;GetFileNameSrc();	// Pega o nome do arquivo de origem -> FileNameSrc
	call	GetFileNameSrc
	
	lea		bx,  fileNameSrc
	cmp		[bx], 0
	je		pulaFimExecucao1
	
	call	concat_par
	jmp		abreArquivo
	
pulaFimExecucao1:
	lea		bx, msgFimExec
	call	printf_s
	
	ret


abreArquivo:
	;if (fopen(FileNameSrc)) {
	;	printf("Erro na abertura do arquivo.\r\n")
	;	exit(1)
	;}
	;FileHandleSrc = BX
	
	;Abre arquivo de origem
	;-
	lea		dx, FileNameSrc			;Salva o endereco do nome do arquivo de origem
	call	fopen					;Abre o arquivo de origem
	mov		FileHandleSrc,bx		;Salva o handle do arquivo de origem
	;-
	
	jnc		Continua1				;Verifica se houve erro an abertura do arquivo
	
	lea		bx, MsgErroOpenFile
	call	printf_s
	
	jmp		read
	
Continua1:

	;GetFileNameDst();	// Pega o nome do arquivo de origem -> FileNameDst
	;call	GetFileNameDst
	
	;lea		bx,  fileNameDst
	;cmp		[bx], 0
	;je		pulaFimExecucao2
	
	call	CriaNomeArqSaida
	
	jmp		criaArqDst

pulaFimExecucao2:
	lea		bx, msgFimExec
	call	printf_s
	
	mov		bx,FileHandleSrc	; Fecha arquivo origem
	call	fclose
	
	ret	
	
	;if (fcreate(FileNameDst)) {
	;	fclose(FileHandleSrc);
	;	printf("Erro na criacao do arquivo.\r\n")
	;	exit(1)
	;}
	;FileHandleDst = BX-
criaArqDst:
	;Cria arquivo de destino
	;-
	lea		dx,FileNameDst			;Salva o endereco do nome do arquivo de destino
	call	fcreate					;Cria o arquivo de destino
	mov		FileHandleDst,bx		;Salva o handle do arquivo de destino
	;-

	jnc		Continua21				;Verifica se deu erro na criacao do arquivo de destino
	
	mov		bx,FileHandleSrc
	call	fclose
	lea		bx, MsgErroCreateFile
	call	printf_s
	
	jmp		read
	
Continua21:
;while(dl != ',')
;Le a altura da parede (esta na primeira linha do arquivo até ',')
dadoAltura:
		mov		bx,FileHandleSrc		
		call	getChar
		jnc		leAltura
		
		lea		bx, MsgErroReadFile
		call	printf_s
		
		mov		bx,FileHandleSrc
		call	fclose
		
		mov		bx,FileHandleDst
		call	fclose
		
		ret
leAltura:		
		cmp		dl, ','					;Verifica se chegou na virgula para ler a largura da parede
		je		dadoLargura
		
		sub		dl, 30h					;Transfere para decimal
		mov		dh, 0
		
		push	dx						;Salva na pilha o valor de dx
		
		mov		ax, 10		;Multiplica por 10 o conteudo de alturaParede
		mul		alturaArquivo
		
		pop		dx
		
		mov		alturaArquivo, ax		;Salva os dados de altura da parede
		mov		alturaAux, ax
		add		alturaArquivo, dx
		add		alturaAux, dx
		
		jmp		dadoAltura
		
		
;while(dl != CR)	
;Le a largura da parede (esta na primeira linha do arquivo apos ',' e ate CR, LF)	
dadoLargura:
		mov		bx,FileHandleSrc
		call	getChar	
		jnc		leLargura				;Verifica se deu erro na leitura
	
		;Se deu erro na abertura:
		lea		bx, MsgErroReadFile		
		call	printf_s
		mov		bx,FileHandleSrc
		call	fclose
		mov		bx,FileHandleDst
		call	fclose
		
		jmp		read
leLargura:
		cmp		dl, CR					;Verifica se cheogu no final da linha
		je		ContinuaX
		
		sub		dl, 30h					;Tranfere para decimal
		mov		dh, 0
		
		push	dx
		
		mov		ax, 10			;Realiza a multiplicacao por 10
		mul		baseArquivo
		
		pop		dx
		
		mov		baseArquivo, ax			;Salva os dados de base da parede
		mov		baseAux, ax
		add		baseArquivo, dx
		add		baseAux, dx
		
		jmp		dadoLargura
	
ContinuaX:	
	call	modo_grafico			;Altera para modo grafico (apaga a tela)
	
	lea		bx, msgAutor			;Printa a mensagem de autoria da parede
	call	printf_s
	
	call	mensagem_rodape
	
	call	define_lado				;define o lado do ladrilho de acordo com o numero de ladrilhos e com a parede (bonus)
	
	mov		posX, 0
	mov		posY, 15
	call	desenha_borda_janela	;desenha a borda d a janela	
	
	
	mov		colunaAtual, 0			;Inicializa as colunas e linhas atuais (para desenhar os ladrilhos)
	mov		linhaAtual, 0
	
	
Continua2:
	;do {
	;	if ( (CF,DL,AX = getChar(FileHandleSrc)) ) {
	;		printf("");
	;		fclose(FileHandleSrc)
	;		fclose(FileHandleDst)
	;		exit(1)
	;	}
	
	mov		bx,FileHandleSrc
	call	getChar
	jnc		Continua3
	
	;Se deu erro na leitura do caractere
	lea		bx, MsgErroReadFile
	call	printf_s
	mov		bx,FileHandleSrc
	call	fclose
	mov		bx,FileHandleDst
	call	fclose
	
	jmp		read
Continua3:
	
	
	;verifica se chegou no final do arquivo
	;	if (AX==0) break;
	cmp		ax,0
	jz		Continua4
	
	
pulaVerificaCor:	
	;Verifica a cor do ladrilho lido do arquivo
	;Entra no loop ate terminar o arquivo
	call	verificaCor
	
	jmp		Continua2
	
	
Continua4:

preto1:

	;Faz a conversao de decimal para ASCII para ser printado no arquivo
	; fprintf_s (String, "%d", #PRETOS);
	mov		ax, PRETO					;NUMCOR guarda o ascii do numero de ladrilhos
	mov		numCor, 0
	lea		bx, numCor
	call	sprintf_w
	
	
	cmp		PRETO, 0
	je		azul1
	
	mov		posY, 440
	mov		posX, 15
	mov		posCursorY, 26
	mov		posCursorX, 2
	mov		cor, 00h
	push	ladoLadrilho
	mov		ladoLadrilho, 24
	call	desenha_rodape
	pop		ladoLadrilho
	
	
	lea		dx, stringPreto				;Move a endereco da string para o dx para ser usado na funcao fprintf_s
	mov		cx, tamPreto				;Quantidqade de caracteres a serem escritos
	call	fprintf_s
	jc		erroEscritaDst
	
	lea		dx, numCor					;Move a endereco da string para o dx para ser usado na funcao fprintf_s
	mov		cx, 3						;Quantidqade de caracteres a serem escritos
	call	fprintf_s
	jc		erroEscritaDst
	
	lea		dx, MsgCRLF2				;Move a endereco da string para o dx para ser usado na funcao fprintf_s
	mov		cx, 2						;Quantidqade de caracteres a serem escritos
	call	fprintf_s
	jc		erroEscritaDst
	
	
	
azul1:
	;Faz a conversao de decimal para ASCII para ser printado no arquivo
	;fprintf_s (String, "%d", #AZUIS);
	mov		ax, AZUL	
	mov 	numCor, 0
	lea		bx, numCor
	call	sprintf_w
	
	
	cmp		AZUL, 0
	je		verde1
	
	mov		posY, 440					;Desenha o rodape
	mov		posX, 52
	mov		posCursorY, 26
	mov		posCursorX, 7
	mov		cor, 01h
	push	ladoLadrilho
	mov		ladoLadrilho, 24
	call	desenha_rodape
	pop		ladoLadrilho
	
	
	lea		dx, stringAzul				;Move a endereco da string para o dx para ser usado na funcao fprintf_s
	mov		cx, tamAzul					;Quantidqade de caracteres a serem escritos
	call	fprintf_s
	jc		erroEscritaDst
	
	lea		dx, numCor				;Move a endereco da string para o dx para ser usado na funcao fprintf_s
	mov		cx, 2						;Quantidqade de caracteres a serem escritos
	call	fprintf_s
	jc		erroEscritaDst
	
	lea		dx, MsgCRLF2				;Move a endereco da string para o dx para ser usado na funcao fprintf_s
	mov		cx, 2						;Quantidqade de caracteres a serem escritos
	call	fprintf_s
	jc		erroEscritaDst
	
verde1:
	;Faz a conversao de decimal para ASCII para ser printado no arquivo
	;fprintf_s (String, "%d", #VERDES);
	mov		ax, VERDE	
	mov 	numCor, 0
	lea		bx, numCor
	call	sprintf_w
	
	
	cmp		VERDE, 0
	je		ciano1
	
	mov		posY, 440					;Desenha o rodape
	mov		posX, 86
	mov		posCursorY, 26
	mov		posCursorX, 11
	mov		cor, 02h
	push	ladoLadrilho
	mov		ladoLadrilho, 24
	call	desenha_rodape
	pop		ladoLadrilho
	
	lea		dx, stringVerde				;Move a endereco da string para o dx para ser usado na funcao fprintf_s
	mov		cx, tamVerde				;Quantidqade de caracteres a serem escritos
	call	fprintf_s
	jc		erroEscritaDst
	
	lea		dx, numCor				;Move a endereco da string para o dx para ser usado na funcao fprintf_s
	mov		cx, 2					;Quantidqade de caracteres a serem escritos
	call	fprintf_s
	jc		erroEscritaDst
	
	lea		dx, MsgCRLF2				;Move a endereco da string para o dx para ser usado na funcao fprintf_s
	mov		cx, 2						;Quantidqade de caracteres a serem escritos
	call	fprintf_s
	jc		erroEscritaDst
	
ciano1:
	;Faz a conversao de decimal para ASCII para ser printado no arquivo
	;fprintf_s (String, "%d", #CIANO);
	mov		ax, CIANO	
	mov 	numCor, 0
	lea		bx, numCor
	call	sprintf_w
	
	
	cmp		CIANO, 0
	je		vermelho1
	
	mov		posY, 440					;Desenha o rodape
	mov		posX, 120
	mov		posCursorY, 26
	mov		posCursorX, 15
	mov		cor, 03h
	push	ladoLadrilho
	mov		ladoLadrilho, 24
	call	desenha_rodape
	pop		ladoLadrilho
	
	
	lea		dx, stringCiano				;Move a endereco da string para o dx para ser usado na funcao fprintf_s
	mov		cx, tamCiano				;Quantidqade de caracteres a serem escritos
	call	fprintf_s
	jc		erroEscritaDst
	
	lea		dx, numCor				;Move a endereco da string para o dx para ser usado na funcao fprintf_s
	mov		cx, 2					;Quantidqade de caracteres a serem escritos
	call	fprintf_s
	jc		erroEscritaDst
	
	lea		dx, MsgCRLF2				;Move a endereco da string para o dx para ser usado na funcao fprintf_s
	mov		cx, 2						;Quantidqade de caracteres a serem escritos
	call	fprintf_s
	jc		erroEscritaDst
vermelho1:
	;Faz a conversao de decimal para ASCII para ser printado no arquivo
	;fprintf_s (String, "%d", #VERMELHO);
	mov		ax, VERMELHO	
	mov 	numCor, 0
	lea		bx, numCor
	call	sprintf_w
	
	
	cmp		VERMELHO, 0
	je		magenta1
	
	mov		posY, 440					;Desenha o rodape
	mov		posX, 154
	mov		posCursorY, 26
	mov		posCursorX, 20
	mov		cor, 04h
	push	ladoLadrilho
	mov		ladoLadrilho, 24
	call	desenha_rodape
	pop		ladoLadrilho
	
	
	lea		dx, stringVermelho				;Move a endereco da string para o dx para ser usado na funcao fprintf_s
	mov		cx, tamVermelho					;Quantidqade de caracteres a serem escritos
	call	fprintf_s
	jc		erroEscritaDst
	
	lea		dx, numCor				;Move a endereco da string para o dx para ser usado na funcao fprintf_s
	mov		cx, 2					;Quantidqade de caracteres a serem escritos
	call	fprintf_s
	jc		erroEscritaDst
	
	lea		dx, MsgCRLF2				;Move a endereco da string para o dx para ser usado na funcao fprintf_s
	mov		cx, 2						;Quantidqade de caracteres a serem escritos
	call	fprintf_s
	jc		erroEscritaDst
magenta1:
	;Faz a conversao de decimal para ASCII para ser printado no arquivo
	;fprintf_s (String, "%d", #VERMELHO);
	mov		ax, MAGENTA	
	mov 	numCor, 0
	lea		bx, numCor
	call	sprintf_w
	
	cmp		MAGENTA, 0
	je		marrom1
	
	mov		posY, 440					;Desenha o rodape
	mov		posX, 188
	mov		posCursorY, 26
	mov		posCursorX, 24
	mov		cor, 05h
	push	ladoLadrilho
	mov		ladoLadrilho, 24
	call	desenha_rodape
	pop		ladoLadrilho
	
	lea		dx, stringMagenta			;Move a endereco da string para o dx para ser usado na funcao fprintf_s
	mov		cx, tamMagenta				;Quantidqade de caracteres a serem escritos
	call	fprintf_s
	jc		erroEscritaDst
	
	lea		dx, numCor				;Move a endereco da string para o dx para ser usado na funcao fprintf_s
	mov		cx, 2					;Quantidqade de caracteres a serem escritos
	call	fprintf_s
	jc		erroEscritaDst
	
	lea		dx, MsgCRLF2				;Move a endereco da string para o dx para ser usado na funcao fprintf_s
	mov		cx, 2						;Quantidqade de caracteres a serem escritos
	call	fprintf_s
	jc		erroEscritaDst
marrom1:
	;Faz a conversao de decimal para ASCII para ser printado no arquivo
	;fprintf_s (String, "%d", #VERMELHO);
	mov		ax, MARROM	
	mov 	numCor, 0
	lea		bx, numCor
	call	sprintf_w
	
	
	cmp		MARROM, 0
	je		cinzaClaro1
	
	mov		posY, 440					;Desenha o rodape
	mov		posX, 222
	mov		posCursorY, 26
	mov		posCursorX, 28
	mov		cor, 06h
	push	ladoLadrilho
	mov		ladoLadrilho, 24
	call	desenha_rodape
	pop		ladoLadrilho
	
	
	lea		dx, stringMarrom			;Move a endereco da string para o dx para ser usado na funcao fprintf_s
	mov		cx, tamMarrom				;Quantidqade de caracteres a serem escritos
	call	fprintf_s
	jc		erroEscritaDst
	
	lea		dx, numCor				;Move a endereco da string para o dx para ser usado na funcao fprintf_s
	mov		cx, 2					;Quantidqade de caracteres a serem escritos
	call	fprintf_s
	jc		erroEscritaDst
	
	lea		dx, MsgCRLF2				;Move a endereco da string para o dx para ser usado na funcao fprintf_s
	mov		cx, 2						;Quantidqade de caracteres a serem escritos
	call	fprintf_s
	jc		erroEscritaDst
cinzaClaro1:
	;Faz a conversao de decimal para ASCII para ser printado no arquivo
	;fprintf_s (String, "%d", #CINZACLARO);
	mov		ax, CINZA_CLARO	
	mov 	numCor, 0
	lea		bx, numCor
	call	sprintf_w
	
	
	cmp		CINZA_CLARO, 0
	je		cinzaEscuro1
	
	mov		posY, 440					;Desenha o rodape
	mov		posX, 256
	mov		posCursorY, 26
	mov		posCursorX, 32
	mov		cor, 07h
	push	ladoLadrilho
	mov		ladoLadrilho, 24
	call	desenha_rodape
	pop		ladoLadrilho
	
	
	lea		dx, stringCinzaClaro		;Move a endereco da string para o dx para ser usado na funcao fprintf_s
	mov		cx, tamCinzaClaro			;Quantidqade de caracteres a serem escritos
	call	fprintf_s
	jc		erroEscritaDst
	
	lea		dx, numCor				;Move a endereco da string para o dx para ser usado na funcao fprintf_s
	mov		cx, 2					;Quantidqade de caracteres a serem escritos
	call	fprintf_s
	jc		erroEscritaDst
	
	lea		dx, MsgCRLF2				;Move a endereco da string para o dx para ser usado na funcao fprintf_s
	mov		cx, 2						;Quantidqade de caracteres a serem escritos
	call	fprintf_s
	jc		erroEscritaDst
cinzaEscuro1:
	;Faz a conversao de decimal para ASCII para ser printado no arquivo
	;fprintf_s (String, "%d", #CINZAESCURO);
	mov		ax, CINZA_ESCURO	
	mov 	numCor, 0
	lea		bx, numCor
	call	sprintf_w
	
	cmp		CINZA_ESCURO, 0
	je		azulClaro1
	
	mov		posY, 440					;Desenha o rodape
	mov		posX, 290
	mov		posCursorY, 26
	mov		posCursorX, 37
	mov		cor, 08h
	push	ladoLadrilho
	mov		ladoLadrilho, 24
	call	desenha_rodape
	pop		ladoLadrilho
	
	lea		dx, stringCinzaEscuro		;Move a endereco da string para o dx para ser usado na funcao fprintf_s
	mov		cx, tamCinzaEscuro			;Quantidqade de caracteres a serem escritos
	call	fprintf_s
	jc		erroEscritaDst
	
	lea		dx, numCor				;Move a endereco da string para o dx para ser usado na funcao fprintf_s
	mov		cx, 2					;Quantidqade de caracteres a serem escritos
	call	fprintf_s
	jc		erroEscritaDst
	
	lea		dx, MsgCRLF2				;Move a endereco da string para o dx para ser usado na funcao fprintf_s
	mov		cx, 2						;Quantidqade de caracteres a serem escritos
	call	fprintf_s
	jc		erroEscritaDst
azulClaro1:
	;Faz a conversao de decimal para ASCII para ser printado no arquivo
	;fprintf_s (String, "%d", #AZULCLARO);
	mov		ax, AZUL_CLARO	
	mov 	numCor, 0
	lea		bx, numCor
	call	sprintf_w
	
	
	cmp		AZUL_CLARO, 0
	je		verdeClaro1
	
	mov		posY, 440					;Desenha o rodape
	mov		posX, 324
	mov		posCursorY, 26
	mov		posCursorX, 41
	mov		cor, 09h
	push	ladoLadrilho
	mov		ladoLadrilho, 24
	call	desenha_rodape
	pop		ladoLadrilho
	
	
	lea		dx, stringAzulClaro			;Move a endereco da string para o dx para ser usado na funcao fprintf_s
	mov		cx, tamAzulClaro			;Quantidqade de caracteres a serem escritos
	call	fprintf_s
	jc		erroEscritaDst
	
	lea		dx, numCor				;Move a endereco da string para o dx para ser usado na funcao fprintf_s
	mov		cx, 2					;Quantidqade de caracteres a serem escritos
	call	fprintf_s
	jc		erroEscritaDst
	
	lea		dx, MsgCRLF2				;Move a endereco da string para o dx para ser usado na funcao fprintf_s
	mov		cx, 2						;Quantidqade de caracteres a serem escritos
	call	fprintf_s
	jc		erroEscritaDst
verdeClaro1:
	;Faz a conversao de decimal para ASCII para ser printado no arquivo
	;fprintf_s (String, "%d", #VERDECLARO);
	mov		ax, VERDE_CLARO	
	mov 	numCor, 0
	lea		bx, numCor
	call	sprintf_w
	
	
	cmp		VERDE_CLARO, 0
	je		cianoClaro1
	
	mov		posY, 440					;Desenha o rodape
	mov		posX, 358
	mov		posCursorY, 26
	mov		posCursorX, 45
	mov		cor, 0Ah
	push	ladoLadrilho
	mov		ladoLadrilho, 24
	call	desenha_rodape
	pop		ladoLadrilho
	
	lea		dx, stringVerdeClaro	;Move a endereco da string para o dx para ser usado na funcao fprintf_s
	mov		cx, tamVerdeClaro		;Quantidqade de caracteres a serem escritos
	call	fprintf_s
	jc		erroEscritaDst
	
	lea		dx, numCor				;Move a endereco da string para o dx para ser usado na funcao fprintf_s
	mov		cx, 2					;Quantidqade de caracteres a serem escritos
	call	fprintf_s
	jc		erroEscritaDst
	
	lea		dx, MsgCRLF2				;Move a endereco da string para o dx para ser usado na funcao fprintf_s
	mov		cx, 2						;Quantidqade de caracteres a serem escritos
	call	fprintf_s
	jc		erroEscritaDst
cianoClaro1:
	;Faz a conversao de decimal para ASCII para ser printado no arquivo
	;fprintf_s (String, "%d", #CIANOCLARO);
	mov		ax, CIANO_CLARO	
	mov 	numCor, 0
	lea		bx, numCor
	call	sprintf_w
	
	
	cmp		CIANO_CLARO, 0
	je		vermelhoClaro1
	
	mov		posY, 440					;Desenha o rodape
	mov		posX, 392
	mov		posCursorY, 26
	mov		posCursorX, 50
	mov		cor, 0Bh
	push	ladoLadrilho
	mov		ladoLadrilho, 24
	call	desenha_rodape
	pop		ladoLadrilho
	
	lea		dx, stringCianoClaro	;Move a endereco da string para o dx para ser usado na funcao fprintf_s
	mov		cx, tamCianoClaro		;Quantidqade de caracteres a serem escritos
	call	fprintf_s
	jc		erroEscritaDst
	
	lea		dx, numCor				;Move a endereco da string para o dx para ser usado na funcao fprintf_s
	mov		cx, 2					;Quantidqade de caracteres a serem escritos
	call	fprintf_s
	jc		erroEscritaDst
	
	lea		dx, MsgCRLF2				;Move a endereco da string para o dx para ser usado na funcao fprintf_s
	mov		cx, 2						;Quantidqade de caracteres a serem escritos
	call	fprintf_s
	jc		erroEscritaDst
vermelhoClaro1:
	;Faz a conversao de decimal para ASCII para ser printado no arquivo
	;fprintf_s (String, "%d", #VERMELHOCLARO);
	mov		ax, VERMELHO_CLARO	
	mov 	numCor, 0
	lea		bx, numCor
	call	sprintf_w
	
	
	cmp		VERMELHO_CLARO, 0
	je		magentaClaro1
	
	mov		posY, 440					;Desenha o rodape
	mov		posX, 426
	mov		posCursorY, 26
	mov		posCursorX, 54
	mov		cor, 0Ch
	push	ladoLadrilho
	mov		ladoLadrilho, 24
	call	desenha_rodape
	pop		ladoLadrilho
	
	lea		dx, stringVermelhoClaro	;Move a endereco da string para o dx para ser usado na funcao fprintf_s
	mov		cx, tamVermelhoClaro	;Quantidqade de caracteres a serem escritos
	call	fprintf_s
	jc		erroEscritaDst
	
	lea		dx, numCor				;Move a endereco da string para o dx para ser usado na funcao fprintf_s
	mov		cx, 2					;Quantidqade de caracteres a serem escritos
	call	fprintf_s
	jc		erroEscritaDst
	
	lea		dx, MsgCRLF2			;Move a endereco da string para o dx para ser usado na funcao fprintf_s
	mov		cx, 2
	call	fprintf_s
	jc		erroEscritaDst
magentaClaro1:
	;Faz a conversao de decimal para ASCII para ser printado no arquivo
	;fprintf_s (String, "%d", #MAGENTACLARO);
	mov		ax, MAGENTA_CLARO	
	mov 	numCor, 0
	lea		bx, numCor
	call	sprintf_w
	
	
	cmp		MAGENTA_CLARO, 0
	je		amarelo1
	
	mov		posY, 440					;Desenha o rodape
	mov		posX, 460
	mov		posCursorY, 26
	mov		posCursorX, 58
	mov		cor, 0Dh
	push	ladoLadrilho
	mov		ladoLadrilho, 24
	call	desenha_rodape
	pop		ladoLadrilho
	
	
	lea		dx, stringMagentaClaro	;Move a endereco da string para o dx para ser usado na funcao fprintf_s
	mov		cx, tamMagentaClaro		;Quantidqade de caracteres a serem escritos
	call	fprintf_s
	jc		erroEscritaDst
	
	
	lea		dx, numCor				;Move a endereco da string para o dx para ser usado na funcao fprintf_s
	mov		cx, 2					;Quantidqade de caracteres a serem escritos
	call	fprintf_s
	jc		erroEscritaDst
	
	;Chama a fprintf_s
	lea		dx, MsgCRLF2				;Move a endereco da string para o dx para ser usado na funcao fprintf_s
	mov		cx, 2	
	call	fprintf_s
	jc		erroEscritaDst
amarelo1:
	;Faz a conversao de decimal para ASCII para ser printado no arquivo
	;fprintf_s (String, "%d", #AMARELO);
	mov		ax, AMARELO	
	mov 	numCor, 0
	lea		bx, numCor
	call	sprintf_w
	
	cmp		AMARELO, 0
	je		branco1
	
	mov		posY, 440					;Desenha o rodape
	mov		posX, 494
	mov		posCursorY, 26
	mov		posCursorX, 62
	mov		cor, 0Eh
	push	ladoLadrilho
	mov		ladoLadrilho, 24
	call	desenha_rodape
	pop		ladoLadrilho
	
	
	lea		dx, stringAmarelo		;Move a endereco da string para o dx para ser usado na funcao fprintf_s
	mov		cx, tamAmarelo			;Quantidqade de caracteres a serem escritos
	call	fprintf_s
	jc		erroEscritaDst
	
	
	lea		dx, numCor				;Move a endereco da string para o dx para ser usado na funcao fprintf_s
	mov		cx, 2					;Quantidqade de caracteres a serem escritos
	call	fprintf_s
	jc		erroEscritaDst
	
	lea		dx, MsgCRLF2			;Move a endereco da string para o dx para ser usado na funcao fprintf_s
	mov		cx, 2
	call	fprintf_s
	jc		erroEscritaDst
branco1:
	;Faz a conversao de decimal para ASCII para ser printado no arquivo
	;fprintf_s (String, "%d", #BRANCO);
	mov		ax, BRANCO	
	mov 	numCor, 0
	lea		bx, numCor
	call	sprintf_w
	
	
	cmp		BRANCO, 0
	je		pulaFimArquivo
	
	mov		posY, 440					;Desenha o rodape
	mov		posX, 528
	mov		posCursorY, 26
	mov		posCursorX, 64
	mov		cor, 0Fh
	push	ladoLadrilho
	mov		ladoLadrilho, 24
	call	desenha_rodape
	pop		ladoLadrilho
	
	lea		dx, stringBranco		;Move a endereco da string para o dx para ser usado na funcao fprintf_s
	mov		cx, tamBranco			;Quantidqade de caracteres a serem escritos
	call	fprintf_s
	jc		erroEscritaDst
	
	lea		dx, numCor				;Move a endereco da string para o dx para ser usado na funcao fprintf_s
	mov		cx, 2					;Quantidqade de caracteres a serem escritos
	call	fprintf_s
	jc		erroEscritaDst
	
	lea		dx, MsgCRLF2			;Move a endereco da string para o dx para ser usado na funcao fprintf_s
	mov		cx, 2
	call	fprintf_s
	jc		erroEscritaDst


pulaFimArquivo:
	jmp		TerminouArquivo

erroEscritaDst:
	lea		bx, MsgErroWriteFile
	call	printf_s
	mov		bx,FileHandleSrc		; Fecha arquivo origem
	call	fclose
	mov		bx,FileHandleDst		; Fecha arquivo destino
	call	fclose
	
	jmp		read
	
	;} while(1);
		
TerminouArquivo:
	;fclose(FileHandleSrc)
	;fclose(FileHandleDst)
	;exit(0)
	
	call	kbhit				;Aguarda o usuario digitar uma tecla para boltar para o loop
	cmp		al, 0
	je 		TerminouArquivo
	
	
	
	
	mov		bx,FileHandleSrc	; Fecha arquivo origem
	call	fclose
	mov		bx,FileHandleDst	; Fecha arquivo destino
	call	fclose
	

	jmp		read
	
fread 	endp
		
;--------------------------------------------------------------------
;Funcao Pede o nome do arquivo de origem salva-o em FileNameSrc
;--------------------------------------------------------------------
GetFileNameSrc	proc	near
	;printf("Nome do arquivo origem: ")
	lea		bx, MsgPedeArquivoSrc
	call	printf_s

	;gets(FileNameSrc);
	lea		bx, FileNameSrc
	call	gets

	;printf("\r\n")
	lea		bx, MsgCRLF
	call	printf_s

fimGetFIleNameSrc:	
	ret
GetFileNameSrc	endp

;****************************************************
;				VERIFICA COR LADRILHO
;****************************************************
;Verifica qual cor foi digitada
;Entra: dl <- caractere


verificaCor	proc	near

	push	ax
	push	bx
	push 	cx
	push 	dx
	
	cmp		baseAux, 0				;verifica se chegou no limite direito da parede
	je		pulaLinhaParede
	cmp		alturaAux, 0			;Verifica se chegou no limite inferior da parede
	je		finalIncParede
	jmp		comparaCor
	
	
pulaLinhaParede:
	inc		linhaAtual
	dec		alturaAux
	
	mov		bx, baseArquivo			;Salva os dados de base da parede
	mov		baseAux, bx
	
	mov		colunaAtual, 0
	

comparaCor:	
	cmp		dl, '0'
	je		incPreto
	cmp		dl, '1'
	je		incAzul
	cmp		dl, '2'
	je		incVerde
	cmp		dl, '3'
	je		incCiano
	cmp		dl, '4'
	je		incVermelho
	cmp		dl, '5'
	je		incMagenta
	cmp		dl, '6'
	je		incMarrom
	cmp		dl, '7'
	je		incCinzaClaro
	cmp		dl, '8'
	je		incCinzaEscuro
	cmp		dl, '9'
	je		incAzulClaro
	cmp		dl, 'A'
	je		incVerdeClaro
	cmp		dl, 'B'
	je		incCianoClaro
	cmp		dl, 'C'
	je		incVermelhoClaro
	cmp		dl, 'D'
	je		incMagentaClaro
	cmp		dl, 'E'
	je		incAmarelo
	cmp		dl, 'F'
	je		incBranco
	
	pop		dx
	pop		cx
	pop		bx
	pop		ax
	ret

incPreto:
	inc		PRETO
	
	call	define_pixel				;Define posX, posY
	
	call	desenha_borda_quadrado		;Desenha a borda branca do quadrado
	
	mov		cor, 00h						;Pinta o ladrilho de preto
	call	pinta_quadrado
	
	inc		colunaAtual
	dec		baseAux


fimIncPreto:	
	pop		dx
	pop		cx
	pop		bx
	pop		ax
	ret
incAzul:
	inc		AZUL
	
	call	define_pixel				;Define posX, posY
	
	call	desenha_borda_quadrado		;Desenha a borda btanca do quadrado
	
	call	define_pixel				;Define posX, posY
	
	mov		cor, 01h						;Pinta o quadrado de azul			
	call	pinta_quadrado
	
	inc		colunaAtual
	dec		baseAux

fimIncAzul:	
	pop		dx
	pop		cx
	pop		bx
	pop		ax
	ret
incVerde:
	inc		VERDE
	
	call	define_pixel				;Define posX, posY
	
	call	desenha_borda_quadrado		;Desenha a borda btanca do quadrado
	
	call	define_pixel				;Define posX, posY
	
	mov		cor, 02h						;Pinta o quadrado de verde			
	call	pinta_quadrado
	
	inc		colunaAtual
	dec		baseAux
	
	
fimIncVerde:	
	pop		dx
	pop		cx
	pop		bx
	pop		ax
	ret
incCiano:
	inc		CIANO
	
	call	define_pixel				;Define posX, posY
	
	call	desenha_borda_quadrado		;Desenha a borda btanca do quadrado
	
	call	define_pixel				;Define posX, posY
	
	mov		cor, 03h						;Pinta o quadrado de ciano			
	call	pinta_quadrado
	
	inc		colunaAtual
	dec		baseAux
	
	
fimIncCiano:	
	pop		dx
	pop		cx
	pop		bx
	pop		ax
	ret
	
	
incVermelho:
	inc		VERMELHO
	
	call	define_pixel				;Define posX, posY
	
	call	desenha_borda_quadrado		;Desenha a borda btanca do quadrado
	
	call	define_pixel				;Define posX, posY
	
	mov		cor, 04h						;Pinta o quadrado de vermelho			
	call	pinta_quadrado
	
	inc		colunaAtual
	dec		baseAux
fimIncVermelho:	
	pop		dx
	pop		cx
	pop		bx
	pop		ax
	ret
	
	
incMagenta:
	inc		MAGENTA
	
	call	define_pixel				;Define posX, posY
	
	call	desenha_borda_quadrado		;Desenha a borda btanca do quadrado
	
	call	define_pixel				;Define posX, posY
	
	mov		cor, 05h						;Pinta o quadrado de magenta			
	call	pinta_quadrado
	
	inc		colunaAtual
	dec		baseAux
fimIncMagenta:	
	pop		dx
	pop		cx
	pop		bx
	pop		ax
	ret

	
incMarrom:
	inc		MARROM	
	
	call	define_pixel				;Define posX, posY
	
	call	desenha_borda_quadrado		;Desenha a borda btanca do quadrado
	
	call	define_pixel				;Define posX, posY
	
	mov		cor, 06h						;Pinta o quadrado de marrom			
	call	pinta_quadrado
	
	inc		colunaAtual
	dec		baseAux
fimIncMarrom:	
	pop		dx
	pop		cx
	pop		bx
	pop		ax	
	ret
	
	
	
incCinzaClaro:
	inc		CINZA_CLARO
	
	call	define_pixel				;Define posX, posY
	
	call	desenha_borda_quadrado		;Desenha a borda btanca do quadrado
	
	call	define_pixel				;Define posX, posY
	
	mov		cor, 07h						;Pinta o quadrado de cinza claro			
	call	pinta_quadrado
	
	inc		colunaAtual
	dec		baseAux
fimIncCinzaClaro:	
	pop		dx
	pop		cx
	pop		bx
	pop		ax
	ret
	

	
incCinzaEscuro:
	inc		CINZA_ESCURO
	
	call	define_pixel				;Define posX, posY
	
	call	desenha_borda_quadrado		;Desenha a borda btanca do quadrado
	
	call	define_pixel				;Define posX, posY
	
	mov		cor, 08h						;Pinta o quadrado de cinza escuro			
	call	pinta_quadrado
	
	inc		colunaAtual
	dec		baseAux
fimIncCinzaEscuro:	
	pop		dx
	pop		cx
	pop		bx
	pop		ax	
	ret
	
	
incAzulClaro:
	inc		AZUL_CLARO
	
	call	define_pixel				;Define posX, posY
	
	call	desenha_borda_quadrado		;Desenha a borda btanca do quadrado
	
	call	define_pixel				;Define posX, posY
	
	mov		cor, 09h						;Pinta o quadrado de azul claro			
	call	pinta_quadrado
	
	inc		colunaAtual
	dec		baseAux
fimIncAzulClaro:	
	pop		dx
	pop		cx
	pop		bx
	pop		ax
	ret
	
	
incVerdeClaro:
	inc		VERDE_CLARO
	
	call	define_pixel				;Define posX, posY
	
	call	desenha_borda_quadrado		;Desenha a borda btanca do quadrado
	
	call	define_pixel				;Define posX, posY
	
	mov		cor, 0Ah						;Pinta o quadrado de verde claro			
	call	pinta_quadrado
	
	inc		colunaAtual
	dec		baseAux
fimIncVerdeClaro:	
	pop		dx
	pop		cx
	pop		bx
	pop		ax
	ret
	
	
incCianoClaro:
	inc		CIANO_CLARO
	
	call	define_pixel				;Define posX, posY
	
	call	desenha_borda_quadrado		;Desenha a borda btanca do quadrado
	
	call	define_pixel				;Define posX, posY
	
	mov		cor, 0Bh						;Pinta o quadrado de ciano claro			
	call	pinta_quadrado
	
	inc		colunaAtual
	dec		baseAux
fimIncCianoClaro:	
	pop		dx
	pop		cx
	pop		bx
	pop		ax
	ret
	
	
incVermelhoClaro:
	inc		VERMELHO_CLARO
	
	call	define_pixel				;Define posX, posY
	
	call	desenha_borda_quadrado		;Desenha a borda btanca do quadrado
	
	call	define_pixel				;Define posX, posY
	
	mov		cor, 0Ch						;Pinta o quadrado de vermelho claro			
	call	pinta_quadrado
	
	inc		colunaAtual
	dec		baseAux
fimIncVermelhoClaro:	
	pop		dx
	pop		cx
	pop		bx
	pop		ax
	ret
	
	
incMagentaClaro:
	inc		MAGENTA_CLARO	
	
	call	define_pixel				;Define posX, posY
	
	call	desenha_borda_quadrado		;Desenha a borda btanca do quadrado
	
	call	define_pixel				;Define posX, posY
	
	mov		cor, 0Dh						;Pinta o quadrado de magenta claro			
	call	pinta_quadrado
	
	inc		colunaAtual
	dec		baseAux
fimIncMagentaClaro:	
	pop		dx
	pop		cx
	pop		bx
	pop		ax
	ret
	
	
incAmarelo:
	inc		AMARELO
	
	call	define_pixel				;Define posX, posY
	
	call	desenha_borda_quadrado		;Desenha a borda btanca do quadrado
	
	call	define_pixel				;Define posX, posY
	
	mov		cor, 0Eh						;Pinta o quadrado de amarelo			
	call	pinta_quadrado
	
	inc		colunaAtual
	dec		baseAux
fimIncAmarelo:	
	pop		dx
	pop		cx
	pop		bx
	pop		ax
	ret
	
	
incBranco:
	inc		BRANCO

	call	define_pixel				;Define posX, posY
	
	call	desenha_borda_quadrado		;Desenha a borda btanca do quadrado
	
	call	define_pixel				;Define posX, posY
	
	mov		cor, 0Fh						;Pinta o quadrado de branco			
	call	pinta_quadrado
	
	inc		colunaAtual
	dec		baseAux	
fimIncBranco:	
	pop		dx
	pop		cx
	pop		bx
	pop		ax
	ret
	
	
finalIncParede:
	pop		dx
	pop		cx
	pop		bx
	pop		ax
	ret
	
verificaCor	endp


;****************************************************
;					GET FILE NAME
;****************************************************
;--------------------------------------------------------------------
;Funcao Pede o nome do arquivo de destino salva-o em FileNameDst
;--------------------------------------------------------------------
GetFileNameDst	proc	near
	;printf("Nome do arquivo destino: ");
	lea		bx, MsgPedeArquivoDst
	call	printf_s
	
	;gets(FileNameDst);
	lea		bx, FileNameDst
	call	gets
	
	;printf("\r\n")
	lea		bx, MsgCRLF
	call	printf_s
	
	ret
GetFileNameDst	endp


;****************************************************
;					FOPEN
;****************************************************
;--------------------------------------------------------------------
;Função	Abre o arquivo cujo nome está no string apontado por DX
;		boolean fopen(char *FileName -> DX)
;Entra: DX -> ponteiro para o string com o nome do arquivo
;Sai:   BX -> handle do arquivo
;       CF -> 0, se OK
;--------------------------------------------------------------------
fopen	proc	near
	mov		al,0			;Modo leitura
	mov		ah,3dh
	int		21h
	mov		bx,ax
	ret
fopen	endp


;****************************************************
;					FCREATE
;****************************************************
;--------------------------------------------------------------------
;Função Cria o arquivo cujo nome está no string apontado por DX
;		boolean fcreate(char *FileName -> DX)
;Sai:   BX -> handle do arquivo
;       CF -> 0, se OK
;--------------------------------------------------------------------
fcreate	proc	near
	mov		cx,0
	mov		ah,3ch
	int		21h
	mov		bx,ax
	ret
fcreate	endp


;****************************************************
;					FCLOSE
;****************************************************
;--------------------------------------------------------------------
;Entra:	BX -> file handle
;Sai:	CF -> "0" se OK
;--------------------------------------------------------------------
fclose	proc	near
	mov		ah,3eh
	int		21h
	ret
fclose	endp


;****************************************************
;					GETCHAR
;****************************************************
;--------------------------------------------------------------------
;Função	Le um caractere do arquivo identificado pelo HANLDE BX
;		getChar(handle->BX)
;Entra: BX -> file handle
;Sai:   dl -> caractere
;		AX -> numero de caracteres lidos
;		CF -> "0" se leitura ok
;--------------------------------------------------------------------
getChar	proc	near
	mov		ah,3fh
	mov		cx,1
	lea		dx,FileBuffer
	int		21h
	mov		dl,FileBuffer
	ret
getChar	endp


;****************************************************
;					SETCHAR
;****************************************************		
;--------------------------------------------------------------------
;Entra: BX -> file handle
;       dl -> caractere
;Sai:   AX -> numero de caracteres escritos
;		CF -> "0" se escrita ok
;--------------------------------------------------------------------
setChar	proc	near
	mov		ah,40h
	mov		cx,1
	mov		FileBuffer,dl
	lea		dx,FileBuffer
	int		21h
	ret
setChar	endp	


;****************************************************
;					GETS
;****************************************************
;
;--------------------------------------------------------------------
;Funcao Le um string do teclado e coloca no buffer apontado por BX
;		gets(char *s -> bx)
;--------------------------------------------------------------------
gets	proc	near
	push	bx

	mov		ah,0ah							; Lê uma linha do teclado
	lea		dx, String
	mov		byte ptr String, MAXSTRING-4	; 2 caracteres no inicio e um eventual CR LF no final
	int		21h

	lea		si,String+2					; Copia do buffer de teclado para o FileName
	pop		di
	mov		cl,String+1
	mov		ch,0
	mov		ax,ds						; Ajusta ES=DS para poder usar o MOVSB
	mov		es,ax
	rep 	movsb

	mov		byte ptr es:[di],0			; Coloca marca de fim de string
	ret
gets	endp

;****************************************************
;					PRINTF
;****************************************************
printf_s	proc	near

;	While (*s!='\0') {
	mov		dl,[bx]
	cmp		dl,0
	je		ps_1

;		putchar(*s)
	push	bx
	mov		ah,2
	int		21H
	pop		bx

;		++s;
	inc		bx
		
;	}
	jmp		printf_s
		
ps_1:
	ret
	
printf_s	endp

;****************************************************
;					FPRINTF_S
;****************************************************
fprintf_s	proc	near
	
	;Chama a interrupcao para print de string no arquivo
	;-
	mov ah, 40h                         ;Escrever
    mov bx, FileHandleDst
    int 21h
	;-
	
	ret

fprintf_s	endp


;****************************************************
;					SPRINTF_W
;****************************************************
;	- Escrever uma rotina para converter um número com 16 bits em um string
;	- O valor de 16 bits entra no registrador AX
;	- O ponteiro para o string entra em DS:BX
;	- Um string é uma seqüência de caracteres ASCII que termina com 00H (‘\0’)

sprintf_w	proc	near

;void sprintf_w(char *string, WORD n) {
	mov		sw_n,ax

;	k=5;
	mov		cx,5
	
;	m=10000;
	mov		sw_m,10000
	
;	f=0;
	mov		sw_f,0
	
;	do {
sw_do:

;		quociente = n / m : resto = n % m;	// Usar instrução DIV
	mov		dx,0
	mov		ax,sw_n
	div		sw_m
	
;		if (quociente || f) {
;			*string++ = quociente+'0'
;			f = 1;
;		}
	cmp		al,0
	jne		sw_store
	cmp		sw_f,0
	je		sw_continue
sw_store:
	add		al,'0'
	mov		[bx],al
	inc		bx
	
	mov		sw_f,1
sw_continue:
	
;		n = resto;
	mov		sw_n,dx
	
;		m = m/10;
	mov		dx,0
	mov		ax,sw_m
	mov		bp,10
	div		bp
	mov		sw_m,ax
	
;		--k;
	dec		cx
	
;	} while(k);
	cmp		cx,0
	jnz		sw_do

;	if (!f)
;		*string++ = '0';
	cmp		sw_f,0
	jnz		sw_continua2
	mov		[bx],'0'
	inc		bx
sw_continua2:


;	*string = '\0';
	mov		byte ptr[bx],0
		
;}
	ret
		
sprintf_w	endp


;****************************************************
;					ATOI
;****************************************************
;Entra: (S) -> DS:BX -> Ponteiro para o string de origem
;Sai:	(A) -> AX -> Valor "Hex" resultante
atoi	proc near

		; A = 0;
		mov		ax,0
		
atoi_2:
		; while (*S!='\0') {
		cmp		byte ptr[bx], 0
		jz		atoi_1

		; 	A = 10 * A
		mov		cx,10
		mul		cx

		; 	A = A + *S
		mov		ch,0
		mov		cl,[bx]
		add		ax,cx

		; 	A = A - '0'
		sub		ax,'0'

		; 	++S
		inc		bx
		
		;}
		jmp		atoi_2

atoi_1:
		; return
		ret
atoi	endp

;****************************************************
;				SET_CURSOR
;****************************************************
;Entra : DL=X, DH=Y.
set_cursor proc
      mov  ah, 2                  ;Setar a posicao do cursor
      mov  bh, 0                  ;Pagina grafica
      int  10h                    ;interrupcao
      RET
set_cursor endp

;****************************************************
;				KBHIT
;****************************************************
;		Retorna:
;			-AL == 0 se nao houve caractere digitado
kbhit	proc	near
	
	
	mov		ah, 0bh
	int		21h
	
	ret
kbhit	endp

;****************************************************
;				CLRBUFFER
;****************************************************
clrbuff	proc	near
	
	
	mov		ah, 0ch
	mov		al, 0
	int		21h
	
	ret
clrbuff	endp


;****************************************************
;				DEFINE_LADO
;****************************************************
;define o lado de cada ladrilho de acordo com a quantidade de ladrilhos e o tamanho da tela (bonus)
;	Entra:
;		-Variavel ladoLadrilho para definir lado
define_lado		proc	near

	mov		ladoLadrilho, 24
	
	push	ax
	push	bx
	push 	cx
	push 	dx
	
	mov		bx, alturaArquivo
	add		bx, 3
	cmp		bx ,baseArquivo
	jae		mudaLadoAltura
	jmp		mudaLadoBase

mudaLadoAltura:
	
	call	multplica_constaltura
	jmp		finalDefine

mudaLadoBase:
	
	call	multplica_constbase
	jmp		finalDefine
	
finalDefine:	
	pop		dx
	pop		cx
	pop		bx
	pop		ax
	ret


define_lado		endp

;****************************************************
;				MULTIPLICA_CONSTALTURA
;****************************************************
multplica_constaltura	proc	near
		push	ax
		push	bx
		push 	cx
		push 	dx
		
		
		;mov		ax, alturaArquivo
		;mul		ladoLadrilho
		;mov		constAltura, ax
		
		mov 	dx, 0
		mov 	ax, 360
		mov 	bx, alturaArquivo
		div 	bx
		mov		ladoLadrilho, ax
		
		;mov		ax, ladoLadrilho
		;mul		constAltura
		;mov		ladoLadrilho, ax
		
			
		pop		dx
		pop		cx
		pop		bx
		pop		ax
		
		ret
		

multplica_constaltura	endp


;****************************************************
;				MULTIPLICA_CONSTBASE
;****************************************************
multplica_constbase	proc	near

		push	ax
		push	bx
		push 	cx
		push 	dx
		
		;mov		ax, baseArquivo
		;mul		ladoLadrilho
		;mov		constBase, ax
		
		mov 	dx, 0        		; clear dividend
		mov 	ax, 624  			 ; dividend
		mov 	bx, baseArquivo    	; divisor
		div 	bx           		; EAX = 0x80, EDX = 0x3
		mov		ladoLadrilho, ax
		
		;mov		ax, ladoLadrilho
		;mul		constBase
		;mov		ladoLadrilho, ax
			
		pop		dx
		pop		cx
		pop		bx
		pop		ax
		
		ret
multplica_constbase	endp



;####################################################
;A logica das funcoes que envolvem modo gráfico
;foi desenvolvida juntamente com o aluno
;Gabriel Pedroso.
;####################################################
;****************************************************
;				DESENHA_BORDA_JANELA
;****************************************************
;Entra:
;	- Coordenada X
;	- Coordenada Y
desenha_borda_janela	proc	near
	push	ax
	push	bx
	push 	cx
	push 	dx
	mov		flagBaseJanela, 640
	mov		flagAlturaJanela, 375
	
linhaCimaJanela:
	cmp		flagBaseJanela, 1
	je		linhaDirJanela

;-
	mov		ah, 0ch			;Liga pixel na tela
	mov		al, 0Eh			;Valor da cor do pixel
	mov		bh, 0			;Numero da pagina Grafica
	mov 	cx, posX		;Move as coordenadas para serem usadas na interrupcao
	mov 	dx, posY
	int 	10h
;-

	dec		flagBaseJanela
	inc		posX
	jmp		linhaCimaJanela
	
linhaDirJanela:
	mov		flagAlturaJanela, 375
	
linhaDirJanela1:
	cmp		flagAlturaJanela, 1
	je		linhaBaixoJanela

;Chama a interrupcao para desenhar pixel
;-	
	mov		ah, 0ch			;Liga pixel na tela
	mov		al, 0Eh			;Valor da cor do pixel
	mov		bh, 0			;Numero da pagina Grafica
	mov 	cx, posX		;Move as coordenadas para serem usadas na interrupcao
	mov 	dx, posY
	
	int 	10h
;-	

	dec		flagAlturaJanela
	inc		posY
	jmp		linhaDirJanela1

linhaBaixoJanela:
	mov		flagBaseJanela, 640
	
linhaBaixoJanela1:
	cmp		flagBaseJanela, 1
	je		linhaEsqJanela

;Chama a interrupcao para desenhar pixel
;-	
	mov		ah, 0ch			;Liga pixel na tela
	mov		al, 0Eh			;Valor da cor do pixel (amarelo)
	mov		bh, 0			;Numero da pagina Grafica
	mov 	cx, posX		;Move as coordenadas para serem usadas na interrupcao
	mov 	dx, posY
	
	int 	10h
;-	

	dec		flagBaseJanela
	dec		posX
	jmp		linhaBaixoJanela1

linhaEsqJanela:
	mov		flagAlturaJanela, 375
	
linhaEsqJanela1:
	cmp		flagAlturaJanela, 1
	je		finalDesenhaJanela

;Chama a interrupcao para desenhar pixel
;-	
	mov		ah, 0ch			;Liga pixel na tela
	mov		al, 0Eh			;Valor da cor do pixel
	mov		bh, 0			;Numero da pagina Grafica
	mov 	cx, posX		;Move as coordenadas para serem usadas na interrupcao
	mov 	dx, posY
	int 	10h
;-	

	dec		flagAlturaJanela
	dec		posY
	jmp		linhaEsqJanela1

finalDesenhaJanela:

	pop		dx
	pop		cx
	pop		bx
	pop		ax

	ret

desenha_borda_janela	endp


;****************************************************
;				DESENHA_BORDA_QUADRADO
;****************************************************
;Entra:
;	- Coordenada X (posX)
;	- Coordenada Y (posY)
desenha_borda_quadrado	proc	near
	;Salva registradores na pilha
	push	ax		
	push	bx
	push 	cx
	push 	dx
	
	mov		bx, ladoLadrilho
	mov		flagLado, bx		;Move a largura do quadrado para flagLado
	
linhaCima:
	cmp		flagLado, 1
	je		linhaDir

;-
	mov		ah, 0ch			;Liga pixel na tela
	mov		al, 0fh			;Valor da cor do pixel
	mov		bh, 0			;Numero da pagina Grafica
	mov 	cx, posX		;Move as coordenadas para serem usadas na interrupcao
	mov 	dx, posY
	int 	10h
;-

	dec		flagLado
	inc		posX
	jmp		linhaCima
	
linhaDir:
	mov		bx, ladoLadrilho
	mov		flagLado, bx		;Move a largura do quadrado para flagLado
	
linhaDir1:
	cmp		flagLado, 1
	je		linhaBaixo

;Chama a interrupcao para desenhar pixel
;-	
	mov		ah, 0ch			;Liga pixel na tela
	mov		al, 0fh			;Valor da cor do pixel
	mov		bh, 0			;Numero da pagina Grafica
	mov 	cx, posX		;Move as coordenadas para serem usadas na interrupcao
	mov 	dx, posY
	
	int 	10h
;-	

	dec		flagLado
	inc		posY
	jmp		linhaDir1

linhaBaixo:
	mov		bx, ladoLadrilho
	mov		flagLado, bx		;Move a largura do quadrado para flagLado
	
linhaBaixo1:
	cmp		flagLado, 1
	je		linhaEsq

;Chama a interrupcao para desenhar pixel
;-	
	mov		ah, 0ch			;Liga pixel na tela
	mov		al, 0fh			;Valor da cor do pixel
	mov		bh, 0			;Numero da pagina Grafica
	mov 	cx, posX		;Move as coordenadas para serem usadas na interrupcao
	mov 	dx, posY
	
	int 	10h
;-	

	dec		flagLado
	dec		posX
	jmp		linhaBaixo1

linhaEsq:
	mov		bx, ladoLadrilho
	mov		flagLado, bx		;Move a largura do quadrado para flagLado
	
linhaEsq1:
	cmp		flagLado, 1
	je		finalDesenhaBorda

;Chama a interrupcao para desenhar pixel
;-	
	mov		ah, 0ch			;Liga pixel na tela
	mov		al, 0fh			;Valor da cor do pixel
	mov		bh, 0			;Numero da pagina Grafica
	mov 	cx, posX		;Move as coordenadas para serem usadas na interrupcao
	mov 	dx, posY
	int 	10h
;-	

	dec		flagLado
	dec		posY
	jmp		linhaEsq1

finalDesenhaBorda:

	pop		dx
	pop		cx
	pop		bx
	pop		ax

	ret

desenha_borda_quadrado	endp

;****************************************************
;				DEFINE_PIXEL
;****************************************************
;Retorna:
;	- Coordenada X (posX)
;	- Coordenada Y (posY)
define_pixel	proc	near
	
	push	ax
	push	dx
	
	mov		ax, ladoLadrilho			;Faz a multiplicacao para determinar o pixel (X, Y) atual
	mul		colunaAtual
	mov		posX, ax
	add		posX, CONSTX
	
	pop		dx
	
	push	dx
	
	mov		ax, ladoLadrilho
	mul		linhaAtual
	mov		posY, ax 
	add		posY, CONSTY
	
	pop		dx
	pop		ax
	
	ret

define_pixel	endp


;****************************************************
;				PINTA_QUADRADO
;****************************************************
;Entra:
;	- Coordenada X (posX)
;	- Coordenada Y (posY)
;	- Cor (cor)

pinta_quadrado	proc	near
	push	ax		
	push	bx
	push 	cx
	push 	dx

	
	;Salva posicoes das coordenadas (x,y) em auxiliares
	mov		ax, posY
	mov		auxY, ax
	mov		ax, posX
	mov		auxX, ax
	
	mov		flagPintaAltura, 1
	mov		flagPintaLargura, 1
;while(flagPintaLargura < ladoLadrilho) 
loopPinta1:	
	inc		posX
	inc		flagPintaLargura
	
	mov		ax, posY
	mov		auxY, ax
	inc		auxY
	
	mov		flagPintaAltura, 2
	
	mov		ax, flagPintaLargura
	cmp		ax, ladoLadrilho
	je		finalPintaQuadrado
;while(flagPintaAltura < ladoLadrilho) 
loopPinta2:
	mov		ax, flagPintaAltura
	cmp		ax, ladoLadrilho
	je		loopPinta1
	
	;Chama a interrupcao para desenhar pixel
;-	
	mov		ah, 0ch			;Liga pixel na tela
	mov		al, cor			;Valor da cor do pixel
	mov		bh, 0			;Numero da pagina Grafica
	mov 	cx, posX		;Move as coordenadas para serem usadas na interrupcao
	mov 	dx, auxY
	int 	10h
;-	

	inc		auxY
	inc		flagPintaAltura
	
	jmp		loopPinta2
	
	
finalPintaQuadrado:

	pop		dx
	pop		cx
	pop		bx
	pop		ax
	
	ret

	
	

pinta_quadrado	endp



;****************************************************
;				DESENHA_RODAPE
;****************************************************
;Entra:
;	- Coordenada X (posX)
;	- Coordenada Y (posY)
;	- Cor (cor)
;	- Numero em ASCII da quantidade de ladrilhos da cor (numCor)
;	- Coordenada X do cursor (posCursorX)
;	- Coordenada Y do cursor (posCursorY)
desenha_rodape	proc	near

	push	ax
	push 	bx
	push	cx
	push	dx
	
	call	desenha_borda_quadrado		;Desenha a borda branca do quadrado
	call	pinta_quadrado				;Pinta o quadrado com respectiva cor
	
	mov		dl, posCursorX
	mov		dh, posCursorY
	call	set_cursor					;Seta a posicao do cursor para printar a qunatidade de quadrados
	
	lea		bx, numCor					;Printa as valores de cada cor
	call	printf_s
	
	
	pop		dx
	pop		cx
	pop		bx
	pop		ax
		
	
	ret

desenha_rodape	endp

;****************************************************
;				MENSAGEM_RODAPE
;****************************************************
;Entra:
;	Nome do arquivo de entrada (fileNameSrc)

mensagem_rodape		proc	near

	mov		dl, 0						;Printa as mensagem rodape
	mov		dh, 25
	call	set_cursor					;Seta a posicao do cursor para printar a qunatidade de quadrados
	lea		bx, msgRodape1					
	call	printf_s
	
	mov		dl, 9						;Printa as mensagem rodape
	mov		dh, 25
	call	set_cursor					;Seta a posicao do cursor para printar a qunatidade de quadrados
	lea		bx, fileNameSrc					
	call	printf_s
	
	mov		dl, 23						;Printa as mensagem rodape
	mov		dh, 25
	call	set_cursor					;Seta a posicao do cursor para printar a qunatidade de quadrados
	lea		bx, msgRodape2					
	call	printf_s
	
	ret
mensagem_rodape		endp

;****************************************************
;				criaArqDst
;****************************************************
;Entra:
;	Nome do arquivo de entrada (fileNameSrc)
;	Subrotina para criar o nome do arquivo de saida a partir do nome do arquivo de entrada
;	Nome do arquivo de entrada sem o .par e adicionando o .rel
CriaNomeArqSaida	proc	near

	push 	bx
	push	cx
	
	lea 	bx, FileNameSrc
	lea		si, FileNameDst
	

ProxCharSaida:
	cmp		byte ptr[bx], '.'
	jz		EhPonto
	mov		cx,	0
	
	mov 	cl, byte ptr[bx]
	mov		byte ptr[si], cl
	
	
	inc		bx
	inc		si
	jmp		ProxCharSaida
	
	
EhPonto:
	mov 	byte ptr[si], '.'
	inc		si
	mov		byte ptr[si], 'r'
	inc		si
	mov		byte ptr[si], 'e'
	inc		si
	mov		byte ptr[si], 'l'
	inc		si
	mov		byte ptr[si], 0
	
	
Acabou_nome:
	pop 	cx
	pop		bx
	ret
	
CriaNomeArqSaida	endp


;****************************************************
;				concat_par
;****************************************************
;Entra:
;	Nome do arquivo de entrada (fileNameSrc)
;	Subrotina para concatenas '.par' no arquivo de entrada caso nao tenha sido digitado

concat_par	proc	near

	push 	bx
	
	lea 	bx, FileNameSrc

loopLeString:	
	cmp		byte ptr[bx], '.'
	jz		comPonto
	cmp		byte ptr[bx], 0
	jz		concatPar
	
	inc		bx
	jmp		loopLeString
	
concatPar:
	mov 	byte ptr[bx], '.'
	inc		bx
	mov		byte ptr[bx], 'p'
	inc		bx
	mov		byte ptr[bx], 'a'
	inc		bx
	mov		byte ptr[bx], 'r'
	inc		bx
	mov		byte ptr[bx], 0
	
comPonto:
	pop		bx
	ret

concat_par	endp


;****************************************************
		end
;****************************************************