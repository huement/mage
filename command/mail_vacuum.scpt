FasdUAS 1.101.10   ��   ��    k             l      ��  ��   ��
Speed up Mail.app by vacuuming the Envelope Index
Code from: http://web.archive.org/web/20071008123746/http://www.hawkwings.net/2007/03/03/scripts-to-automate-the-mailapp-envelope-speed-trick/
Originally by "pmbuko" with modifications by Romulo
Updated by Brett Terpstra 2012
Updated by Mathias T�rnblom 2015 to support V3 in El Capitan and still keep backwards compatibility
Updated by Andrei Miclaus 2017 to support V4 in Sierra
     � 	 	` 
 S p e e d   u p   M a i l . a p p   b y   v a c u u m i n g   t h e   E n v e l o p e   I n d e x 
 C o d e   f r o m :   h t t p : / / w e b . a r c h i v e . o r g / w e b / 2 0 0 7 1 0 0 8 1 2 3 7 4 6 / h t t p : / / w w w . h a w k w i n g s . n e t / 2 0 0 7 / 0 3 / 0 3 / s c r i p t s - t o - a u t o m a t e - t h e - m a i l a p p - e n v e l o p e - s p e e d - t r i c k / 
 O r i g i n a l l y   b y   " p m b u k o "   w i t h   m o d i f i c a t i o n s   b y   R o m u l o 
 U p d a t e d   b y   B r e t t   T e r p s t r a   2 0 1 2 
 U p d a t e d   b y   M a t h i a s   T � r n b l o m   2 0 1 5   t o   s u p p o r t   V 3   i n   E l   C a p i t a n   a n d   s t i l l   k e e p   b a c k w a r d s   c o m p a t i b i l i t y 
 U p d a t e d   b y   A n d r e i   M i c l a u s   2 0 1 7   t o   s u p p o r t   V 4   i n   S i e r r a 
   
  
 l     ��������  ��  ��        l    
 ����  O    
    I   	������
�� .aevtquitnull��� ��� null��  ��    m       �                                                                                  emal  alis    *  OSX                        ���QH+     �Mail.app                                                          ���        ����  	                Applications    ��;�      ��j       �  OSX:Applications: Mail.app    M a i l . a p p    O S X  Applications/Mail.app   / ��  ��  ��        l    ����  r        I   �� ��
�� .sysoexecTEXT���     TEXT  m       �   . s w _ v e r s   - p r o d u c t V e r s i o n��    o      ���� 0 
os_version  ��  ��        l    ����  r        m       �      V 2  o      ���� 0 mail_version  ��  ��     ! " ! l   8 #���� # P    8 $ %�� $ k    7 & &  ' ( ' Z   ) ) *���� ) B     + , + m     - - � . . 
 1 0 . 1 0 , o    ���� 0 
os_version   * r   " % / 0 / m   " # 1 1 � 2 2  V 3 0 o      ���� 0 mail_version  ��  ��   (  3�� 3 Z  * 7 4 5���� 4 A   * - 6 7 6 m   * + 8 8 � 9 9 
 1 0 . 1 2 7 o   + ,���� 0 
os_version   5 r   0 3 : ; : m   0 1 < < � = =  V 4 ; o      ���� 0 mail_version  ��  ��  ��   % ����
�� consnume��  ��  ��  ��   "  > ? > l     ��������  ��  ��   ?  @ A @ l  9 D B���� B r   9 D C D C I  9 B�� E��
�� .sysoexecTEXT���     TEXT E b   9 > F G F b   9 < H I H m   9 : J J � K K 0 l s   - l n a h   ~ / L i b r a r y / M a i l / I o   : ;���� 0 mail_version   G m   < = L L � M M p / M a i l D a t a   |   g r e p   - E   ' E n v e l o p e   I n d e x $ '   |   a w k   { ' p r i n t   $ 5 ' }��   D o      ���� 0 
sizebefore 
sizeBefore��  ��   A  N O N l  E P P���� P I  E P�� Q��
�� .sysoexecTEXT���     TEXT Q b   E L R S R b   E H T U T m   E F V V � W W @ / u s r / b i n / s q l i t e 3   ~ / L i b r a r y / M a i l / U o   F G���� 0 mail_version   S m   H K X X � Y Y @ / M a i l D a t a / E n v e l o p e \   I n d e x   v a c u u m��  ��  ��   O  Z [ Z l     ��������  ��  ��   [  \ ] \ l  Q b ^���� ^ r   Q b _ ` _ I  Q ^�� a��
�� .sysoexecTEXT���     TEXT a b   Q Z b c b b   Q V d e d m   Q T f f � g g 0 l s   - l n a h   ~ / L i b r a r y / M a i l / e o   T U���� 0 mail_version   c m   V Y h h � i i p / M a i l D a t a   |   g r e p   - E   ' E n v e l o p e   I n d e x $ '   |   a w k   { ' p r i n t   $ 5 ' }��   ` o      ���� 0 	sizeafter 	sizeAfter��  ��   ]  j k j l     ��������  ��  ��   k  l m l l  c � n���� n I  c ��� o��
�� .sysodlogaskr        TEXT o l  c � p���� p b   c � q r q b   c | s t s b   c x u v u b   c t w x w b   c p y z y b   c l { | { b   c h } ~ } m   c f   � � � & M a i l   i n d e x   b e f o r e :   ~ o   f g���� 0 
sizebefore 
sizeBefore | o   h k��
�� 
ret  z m   l o � � � � � $ M a i l   i n d e x   a f t e r :   x o   p s���� 0 	sizeafter 	sizeAfter v o   t w��
�� 
ret  t o   x {��
�� 
ret  r m   |  � � � � � ( E n j o y   t h e   n e w   s p e e d !��  ��  ��  ��  ��   m  � � � l     ��������  ��  ��   �  ��� � l  � � ����� � O  � � � � � I  � �������
�� .miscactvnull��� ��� null��  ��   � m   � � � ��                                                                                  emal  alis    *  OSX                        ���QH+     �Mail.app                                                          ���        ����  	                Applications    ��;�      ��j       �  OSX:Applications: Mail.app    M a i l . a p p    O S X  Applications/Mail.app   / ��  ��  ��  ��       �� � ���   � ��
�� .aevtoappnull  �   � **** � �� ����� � ���
�� .aevtoappnull  �   � **** � k     � � �   � �   � �   � �  ! � �  @ � �  N � �  \ � �  l � �  �����  ��  ��   �   �  �� ���� �� % - 1 8 < J L�� V X f h�� �� � �����
�� .aevtquitnull��� ��� null
�� .sysoexecTEXT���     TEXT�� 0 
os_version  �� 0 mail_version  �� 0 
sizebefore 
sizeBefore�� 0 	sizeafter 	sizeAfter
�� 
ret 
�� .sysodlogaskr        TEXT
�� .miscactvnull��� ��� null�� �� *j UO�j E�O�E�O�g �� �E�Y hO�� �E�Y hVO��%�%j E�O��%a %j Oa �%a %j E` Oa �%_ %a %_ %_ %_ %a %j O� *j U ascr  ��ޭ