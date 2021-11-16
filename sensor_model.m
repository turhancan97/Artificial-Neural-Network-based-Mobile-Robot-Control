%% Sensor Model
% it takes angle and distance parameters from relative location function
% and gives the sensor parameters as output.
function sensoroutput = sensor_model(angle, distance)
   
	kat = angle;
	odl = distance;	

	% next comments in Polish

    global Poz_cz1 Poz_cz2 Poz_cz3 kat_cz_max kat_cz_min odl_cz_max Output_cz_max
    
    % k¹t odchylenia Ÿród³a œwiat³a widzianego z uk³adu czujnikow
    kat_cz1 = kat - Poz_cz1(3);
    kat_cz2 = kat - Poz_cz2(3);
    kat_cz3 = kat - Poz_cz3(3);

    % wspolrzedne Ÿród³a œwiat³a w uk³adzie zwi¹zanym z robotem
    X_swiatla = - sin(kat*(pi/180))*odl;
    Y_swiatla = cos(kat*(pi/180))*odl;
    
    % wspolrzedne Ÿród³a œwiat³a w uk³adach lokalnych czujników
    wsp_swiatla_cz1 = transform_coord([X_swiatla Y_swiatla 0],Poz_cz1);
    wsp_swiatla_cz2 = transform_coord([X_swiatla Y_swiatla 0],Poz_cz2);
    wsp_swiatla_cz3 = transform_coord([X_swiatla Y_swiatla 0],Poz_cz3);
    
    % odleglosc zrodla swiatla w ukladzie lokalnym czujnikow
    odl_cz1 = norm(wsp_swiatla_cz1(1:3));
    odl_cz2 = norm(wsp_swiatla_cz2(1:3));
    odl_cz3 = norm(wsp_swiatla_cz3(1:3));
    
       
    % wyliczenie wartoœci na wyjœciu czujników - przy za³o¿eniu liniowej
    % charakterystyki
    
    % czujnik 1
    
    if (odl_cz1 >= 0 & odl_cz1 <= odl_cz_max & wsp_swiatla_cz1(2)>=0)
        if (abs(kat_cz1) <= kat_cz_max )
            Output_cz1 = Output_cz_max*((kat_cz_max - abs(kat_cz1))/kat_cz_max * (odl_cz_max-odl_cz1)/odl_cz_max);
        else
            Output_cz1 = 0;
        end    
    else 
        Output_cz1 = 0;
    end 
    
    % czujnik 2
    if (odl_cz2 >= 0 & odl_cz2 <= odl_cz_max & wsp_swiatla_cz2(2)>=0)
        if (abs(kat_cz2) <= kat_cz_max )
            Output_cz2 = Output_cz_max*((kat_cz_max - abs(kat_cz2))/kat_cz_max * (odl_cz_max-odl_cz2)/odl_cz_max);
        else
            Output_cz2 = 0;
        end    
    else 
        Output_cz2 = 0;
    end 
    
    %   czujnik 3
    if (odl_cz3 >= 0 & odl_cz3 <= odl_cz_max & wsp_swiatla_cz2(3)>=0)
        if (abs(kat_cz3) <= kat_cz_max )
            Output_cz3 = Output_cz_max*((kat_cz_max - abs(kat_cz3))/kat_cz_max * (odl_cz_max-odl_cz3)/odl_cz_max);
        else
            Output_cz3 = 0;
        end    
    else 
        Output_cz3 = 0;
    end 
    
    % zwracany wynik analogowych wyjœæ z czujnika
    sensoroutput = [Output_cz1; Output_cz2; Output_cz3];
    
function wsp_lokalne_czujnika = transform_coord(wektor,Poz_cz)

        % funckja dokonuje trasformacji wspolrzednych wektora do ukladu lokalnego 
        % czujnika

        % parametry wejœciowe:
        % wektor - wektor, którego wspó³rzêdne nale¿y wyznaczyæ w uk³adzie
        %          lokalnym czujnika
        % Poz_cz - wektor po³o¿enia i orientacji czujnika wzglêdem uk³adu
        %          zwiazanego z robotem

    Teta_rad = Poz_cz(3)*pi/180;
    Transf = [cos(Teta_rad) sin(Teta_rad) 0  -(cos(Teta_rad)*Poz_cz(1)+sin(Teta_rad)*Poz_cz(2));
             -sin(Teta_rad) cos(Teta_rad) 0  -(-sin(Teta_rad)*Poz_cz(1)+cos(Teta_rad)*Poz_cz(2));
             0              0             1  0;
             0              0             0  1];

    wsp_lokalne_czujnika = Transf*[wektor(1);wektor(2);wektor(3);1];