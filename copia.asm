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
	
	alturaArquivo	dw	0
	baseArquivo		dw 	0
	linhaLida		dw 	0
	tamStringNum	dw	0
	aux				dw	0
	.code
	.startup
	
	;Inicializa as variaveis
	mov		linhaLida, 0
	mov		alturaArquivo, 0
	mov		baseArquivo, 0
	mov		aux, 0
	
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
	
	mov		ah, 0
	mov		al, 07h
	int		10h
	
	ret

modo_texto	endp

;****************************************************
;					MODO TEXTO
;****************************************************
modo_grafico	proc	near
	
	mov		ah, 0
	mov		al, 11h
	int		10h
	
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

	;GetFileNameSrc();	// Pega o nome do arquivo de origem -> FileNameSrc
	call	GetFileNameSrc
	
	lea		bx,  fileNameSrc
	cmp		[bx], 0
	je		pulaFimExecucao1
	jmp		abreArquivo
	
pulaFimExecucao1:
	lea		bx, msgFimExec
	call	printf_s
	
	mov		bx,FileHandleSrc	; Fecha arquivo origem
	call	fclose
	
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
	
	ret
	
Continua1:

	;GetFileNameDst();	// Pega o nome do arquivo de origem -> FileNameDst
	call	GetFileNameDst
	
	lea		bx,  fileNameDst
	cmp		[bx], 0
	je		pulaFimExecucao2
	jmp		criaArqDst

pulaFimExecucao2:
	lea		bx, msgFimExec
	call	printf_s
	
	mov		bx,FileHandleSrc	; Fecha arquivo origem
	call	fclose
	mov		bx,FileHandleDst	; Fecha arquivo origem
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
	
	ret
	
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
		
		mov		bx, alturaArquivo		;Multiplica por 10 o conteudo de alturaParede
		mov		ax, 10
		mul		bx
		
		pop		dx
		
		mov		alturaArquivo, bx
		add		alturaArquivo, dx
		
		jmp		dadoAltura
		
		
;while(dl != CR)	
;Le a largura da parede (esta na primeira linha do arquivo apos ',' e ate CR, LF)	
dadoLargura:
		mov		bx,FileHandleSrc
		call	getChar	
		jnc		leLargura				;Verifica se deu erro na leitura
		
		lea		bx, MsgErroReadFile
		call	printf_s
		
		mov		bx,FileHandleSrc
		call	fclose
		
		mov		bx,FileHandleDst
		call	fclose
		
		ret
leLargura:
		cmp		dl, CR					;Verifica se cheogu no final da linha
		je		Continua2
		
		sub		dl, 30h					;Tranfere para decimal
		mov		dh, 0
		
		push	dx
		
		mov		bx, baseArquivo			;Realiza a multiplicacao por 10
		mov		ax, 10
		mul		bx
		
		pop		dx
		
		mov		alturaArquivo, bx
		add		alturaArquivo, dx
		
		jmp		dadoLargura
	
	
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
	
	lea		bx, MsgErroReadFile
	call	printf_s
	
	mov		bx,FileHandleSrc
	call	fclose
	
	mov		bx,FileHandleDst
	call	fclose
	
	ret
Continua3:

	;	if (AX==0) break;
	cmp		ax,0
	jz		Continua4
	
	
pulaVerificaCor:	
	;Verifica a cor do ladrilho lido do arquivo
	call	verificaCor
	
	jmp		Continua2
	
	
Continua4:

preto1:

	;Faz a conversao de decimal para ASCII para ser printado no arquivo
	; fprintf_s (String, "%d", #PRETOS);
	mov		ax, PRETO
	mov		numCor, 0
	lea		bx, numCor
	call	sprintf_w
	
	cmp		PRETO, 0
	je		azul1
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
	
	ret
	
	;} while(1);
		
TerminouArquivo:
	;fclose(FileHandleSrc)
	;fclose(FileHandleDst)
	;exit(0)
	mov		bx,FileHandleSrc	; Fecha arquivo origem
	call	fclose
	mov		bx,FileHandleDst	; Fecha arquivo destino
	call	fclose
	

	ret
	
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
	ret

incPreto:
	inc		PRETO
	ret
incAzul:
	inc		AZUL
	ret
incVerde:
	inc		VERDE
	ret
incCiano:
	inc		CIANO
	ret
incVermelho:
	inc		VERMELHO
	ret
incMagenta:
	inc		MAGENTA
	ret
incMarrom:
	inc		MARROM
	ret
incCinzaClaro:
	inc		CINZA_CLARO
	ret
incCinzaEscuro:
	inc		CINZA_ESCURO
	ret
incAzulClaro:
	inc		AZUL_CLARO
	ret
incVerdeClaro:
	inc		VERDE_CLARO
	ret
incCianoClaro:
	inc		CIANO_CLARO
	ret
incVermelhoClaro:
	inc		VERMELHO_CLARO
	ret
incMagentaClaro:
	inc		MAGENTA_CLARO
	ret
incAmarelo:
	inc		AMARELO
	ret
incBranco:
	inc		BRANCO
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
		end
;****************************************************