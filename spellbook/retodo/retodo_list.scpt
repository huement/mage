FasdUAS 1.101.10   ��   ��    k             l     ��������  ��  ��        l     �� 	 
��   	 "  Text file to Reminders List    
 �   8   T e x t   f i l e   t o   R e m i n d e r s   L i s t      l     ��������  ��  ��        l     ��������  ��  ��        l     ��  ��    � � Change this to the path to your downloaded text file with your tasks in it! (Note the : instead of a / between folders) Or, just name them Reminders.txt and put them in your downloads folder     �  ~   C h a n g e   t h i s   t o   t h e   p a t h   t o   y o u r   d o w n l o a d e d   t e x t   f i l e   w i t h   y o u r   t a s k s   i n   i t !   ( N o t e   t h e   :   i n s t e a d   o f   a   /   b e t w e e n   f o l d e r s )   O r ,   j u s t   n a m e   t h e m   R e m i n d e r s . t x t   a n d   p u t   t h e m   i n   y o u r   d o w n l o a d s   f o l d e r      l    
 ����  r     
    l     ����  I    �� ��
�� .rdwrread****        ****  4     �� 
�� 
file  m       �   > U s e r s : e v e : D e s k t o p : r e m i n d e r s . t x t��  ��  ��    o      ���� "0 thefilecontents theFileContents��  ��         l    !���� ! r     " # " n     $ % $ 2   ��
�� 
cpar % o    ���� "0 thefilecontents theFileContents # o      ���� 0 thelines theLines��  ��      & ' & l    ( ) * ( r     + , + [     - . - l    /���� / I   ������
�� .misccurdldt    ��� null��  ��  ��  ��   . l    0���� 0 ]     1 2 1 ]     3 4 3 m    ���� H 4 m    ���� < 2 m    ���� <��  ��   , o      ���� 0 tomorrow Tomorrow )   Really 3 days from now    * � 5 5 .   R e a l l y   3   d a y s   f r o m   n o w '  6 7 6 l   $ 8���� 8 r    $ 9 : 9 l   " ;���� ; n    " < = < 1     "��
�� 
dstr = o     ���� 0 tomorrow Tomorrow��  ��   : o      ���� 0 
mytomorrow 
myTomorrow��  ��   7  > ? > l  % , @���� @ r   % , A B A I  % *������
�� .misccurdldt    ��� null��  ��   B o      ���� 	0 today  ��  ��   ?  C D C l  - 2 E���� E r   - 2 F G F n   - 0 H I H m   . 0��
�� 
wkdy I o   - .���� 	0 today   G o      ���� 0 twd  ��  ��   D  J K J l     ��������  ��  ��   K  L M L l     ��������  ��  ��   M  N O N l  3 � P���� P O   3 � Q R Q k   7 � S S  T U T l  7 7�� V W��   V 3 - Default or custom name. TODO. create a list.    W � X X Z   D e f a u l t   o r   c u s t o m   n a m e .   T O D O .   c r e a t e   a   l i s t . U  Y Z Y l  7 7�� [ \��   [ %  set mylist to the default list    \ � ] ] >   s e t   m y l i s t   t o   t h e   d e f a u l t   l i s t Z  ^ _ ^ r   7 C ` a ` 4   7 ?�� b
�� 
list b l  ; > c���� c m   ; > d d � e e  T o D o��  ��   a o      ���� 
0 mylist   _  f g f O   D � h i h X   J � j�� k j k   ^ � l l  m n m r   ^ t o p o I  ^ p���� q
�� .corecrel****      � null��   q �� r s
�� 
kocl r m   b e��
�� 
remi s �� t��
�� 
insh t  ;   h j��   p o      ���� 0 newremin   n  u v u r   u ~ w x w o   u v���� 0 eachline eachLine x n       y z y 1   y }��
�� 
pnam z o   v y���� 0 newremin   v  { | { r    � } ~ } l   � ����  c    � � � � b    � � � � o    ����� 0 twd   � m   � � � � � � �    7 2 � m   � ���
�� 
TEXT��  ��   ~ n       � � � 1   � ���
�� 
body � o   � ����� 0 newremin   |  � � � r   � � � � � l  � � ����� � c   � � � � � m   � ����� 	 � m   � ���
�� 
long��  ��   � n       � � � 1   � ���
�� 
prio � o   � ����� 0 newremin   �  ��� � r   � � � � � o   � ����� 0 tomorrow Tomorrow � n       � � � 1   � ���
�� 
dued � o   � ����� 0 newremin  ��  �� 0 eachline eachLine k o   M N���� 0 thelines theLines i o   D G���� 
0 mylist   g  � � � l  � ���������  ��  ��   �  � � � I  � ��� � �
�� .sysonotfnull��� ��� TEXT � b   � � � � � l  � � ����� � c   � � � � � l  � � ����� � I  � ��� ���
�� .corecnte****       **** � o   � ����� 0 thelines theLines��  ��  ��   � m   � ���
�� 
TEXT��  ��   � m   � � � � � � � &   R e m i n d e r s   c r e a t e d ! � �� � �
�� 
nsou � m   � � � � � � �  P u r r � �� ���
�� 
appr � l  � � ����� � b   � � � � � m   � � � � � � �  M u m f o r d _ � o   � ����� 0 twd  ��  ��  ��   �  ��� � l  � � � � � � I  � ��� ���
�� .sysodelanull��� ��� nmbr � m   � ����� ��   � 2 ,> allow time for the notification to trigger    � � � � X >   a l l o w   t i m e   f o r   t h e   n o t i f i c a t i o n   t o   t r i g g e r��   R m   3 4 � ��                                                                                  rmnd  alis    >  OSX                        ���QH+     �Reminders.app                                                     �Ӑ��        ����  	                Applications    ��;�      Ӑ��       �  OSX:Applications: Reminders.app     R e m i n d e r s . a p p    O S X  Applications/Reminders.app  / ��  ��  ��   O  � � � l     ��������  ��  ��   �  ��� � l     ��������  ��  ��  ��       �� � ���   � ��
�� .aevtoappnull  �   � **** � � ��~�} � ��|
� .aevtoappnull  �   � **** � k     � � �   � �   � �  & � �  6 � �  > � �  C � �  N�{�{  �~  �}   � �z�z 0 eachline eachLine � *�y �x�w�v�u�t�s�r�q�p�o�n�m�l ��k d�j�i�h�g�f�e�d�c�b�a ��`�_�^�]�\�[ ��Z ��Y ��X�W
�y 
file
�x .rdwrread****        ****�w "0 thefilecontents theFileContents
�v 
cpar�u 0 thelines theLines
�t .misccurdldt    ��� null�s H�r <�q 0 tomorrow Tomorrow
�p 
dstr�o 0 
mytomorrow 
myTomorrow�n 	0 today  
�m 
wkdy�l 0 twd  
�k 
list�j 
0 mylist  
�i 
kocl
�h 
cobj
�g .corecnte****       ****
�f 
remi
�e 
insh�d 
�c .corecrel****      � null�b 0 newremin  
�a 
pnam
�` 
TEXT
�_ 
body�^ 	
�] 
long
�\ 
prio
�[ 
dued
�Z 
nsou
�Y 
appr
�X .sysonotfnull��� ��� TEXT
�W .sysodelanull��� ��� nmbr�| �*��/j E�O��-E�O*j �� � E�O��,E�O*j E�O��,E�O� �*a a /E` O_  g d�[a a l kh  *a a a *6a  E` O�_ a ,FO�a %a &_ a ,FOa a  &_ a !,FO�_ a ",F[OY��UO�j a &a #%a $a %a &a '�%a  (Okj )Uascr  ��ޭ