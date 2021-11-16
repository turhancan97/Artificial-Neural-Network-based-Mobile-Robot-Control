clc
clear all
%% Initialization Codes for Robort's Parameters
global r d
d = 10; % Distance between wheels in cm
r = 3; % Wheel radius in cm
%% Sensor Position in the Robot Frame
% 1 - left sensor
% 2 - front sensor
% 3 - right sensor
global Poz_cz1 Poz_cz2 Poz_cz3 kat_cz_max kat_cz_min odl_cz_max Output_cz_max ile_przedz

Poz_cz1 = [-(d/2-1) (d/2-1)  30]; % dla d=10 : [-4 4 30]
Poz_cz2 = [   0     (d/2-1)   0]; %            [ 0 4  0] 
Poz_cz3 = [ (d/2-1) (d/2-1) -30]; %            [ 4 4 -30]
kat_cz_max = 25;   %deg
kat_cz_min = -25;  %deg
odl_cz_max = 50;   %cm
Output_cz_max = 5; %V
ile_przedz = 5;

global XP1_1 XP2_1 XP3_1 XP4_1 XPW5_1
global YP1_1 YP2_1 YP3_1 YP4_1 YPW5_1
   
XP1_1=d/2;
YP1_1=d/2;
XP2_1=-d/2;
YP2_1=d/2;
XP3_1=-d/2;
YP3_1=-d/2;
XP4_1=d/2;
YP4_1=-d/2;
XPW5_1=0;
YPW5_1=d/2+3;
%   PredkoscKolkaMAX - maksymalna liniowa predkosc kolka
global PredkoscKolkaMAX
PredkoscKolkaMAX=8;
%   WspSkalujacyCzas - Wspolczynnik skalujacy czas symulacji
global WspSkalujacyCzas
WspSkalujacyCzas=1;
% parametr opisuj¹cy czas ruchu do punktu docelowego
%global wyliczony_czas
% parametr opisujacy wielkosc wyswietlanej przestrzeni
global SzerEkr
SzerEkr=50;
% odleglosc swiatla od srodka robota uzywana do uczenia sieci neuronowej
global OdlUczeniaSieci
OdlUczeniaSieci=25;