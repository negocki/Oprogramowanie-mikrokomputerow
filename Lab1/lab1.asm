;   PROGRAM  "lab1.asm"
dane SEGMENT 	;segment danych

Tablica1 db '73623854295121802353287342713810',"$" ;mozna modyfikowac, max 64 cyfry
Tablica2 db 64 dup ("$")

dane ENDS

rozkazy SEGMENT 'CODE' use16 	;segment zawierający rozkazy programu
		ASSUME cs:rozkazy, ds:dane
wystartuj:
		mov ax, SEG dane
		mov ds, ax ;ustawiamy dane jako segment danych DS
		mov cx, Tablica2-Tablica1-2 ;dlugosc petli bo CX jest od petli
		mov bx, OFFSET Tablica1 	;wpisanie do rejestru BX obszaru zawierającego wyswietlany tekst
		mov si, OFFSET Tablica2
		mov dx, bx 	;wpisanie do rejestru DL kodu ASCII kolejnego wyświetlanego znaku
		mov ah, 9 ;wyswietlenie
		int 21H 	;wyświetlenie znaku za pomocą funkcji nr 2 DOS
		mov bx, OFFSET Tablica1 

pierwszy_element: ;tylko dla pierwszego elementu przepisujemy go bez zmian
		mov dl, [bx] 	;wpisanie do rejestru DL kodu ASCII
		mov [si], dl
		inc bx ;nastepne znaki w tablicy
		inc si
ptl:
		mov al, 0
		mov dl, [bx]	;do dl aktualny znak z tablicy 1
		mov al, [bx-1]  ;do al poprzedni znak z tablicy 1	
		sub dl, 30H ;odjecie 30H -> zamiana z ascii na liczbe
		sub al, 30H	
		add dl,al  ;dodajemy liczby
		cmp dl, 10 ;sprawdzamy czy suma jest wieksza lub rowna od 10, jezeli tak to skok nizej
		jg wiekszy
		jz zero
		
powrot:
		add dl, 30H  ;dodajemy 30H -> zamieniamy liczbe na ASCII
		mov [si], dl ;wpisujemy znak do tablicy 2
		inc bx
		inc si
		jmp koniec_petli
		
wiekszy:
		sub dl,10 ;odejmujemy 10
		jmp powrot
		
zero:
		mov dl,0  ;suma jest rowna 10 wiec ustawiamy 0
		jmp powrot
		
koniec_petli:

loop ptl ;sterowanie petla

wyswietl_tablica2:
		mov dl, 13
		mov ah, 2
		int 21H 	;przejscie do nowej linii - znaki 13,10
		mov dl, 10
		mov ah, 2
		int 21H 	
		mov bx, OFFSET Tablica2	;wypisanie Tablicy 2 az do znaku $			
		mov dx, bx 	
		mov ah, 9
		int 21H 	;wyświetlenie znaku za pomocą funkcji nr 2 DOS		
				
koniec:
		mov ah, 4CH 	;zakończenie programu – przekazanie sterowania
				;do systemu, za pomocą funkcji 4CH DOS
		int 21H
rozkazy ENDS

nasz_stos SEGMENT stack 	;segment stosu
dw 128 dup (?)
nasz_stos ENDS

END wystartuj 			;wykonanie programu zacznie się od rozkazu
				;opatrzonego etykietą wystartuj
