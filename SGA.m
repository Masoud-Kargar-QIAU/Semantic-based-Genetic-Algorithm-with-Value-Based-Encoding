clear
close all
%% set Parameters

% FileNumber=179;
load('D:\Mozilla\accessible\data\accessible');
maxiter=3000;      % max of iteration
ConstIteration=100;

npop=300;
ncross=200;
nmut=400;

OutputNumber=1;
DirName='d:\Mozilla\accessible\output\';
OutputMoJo=strcat(DirName,'MoJo\Mozilla_accessible_SGA_',num2str(OutputNumber),'.rsf');
OutputPreRecall=strcat(DirName,'PreRecall\BestPop_SGA_',num2str(OutputNumber));

FigureDir=strcat(DirName,'Figure\SGA\',num2str(OutputNumber));
mkdir(FigureDir);


%% initialization

BEST=zeros(maxiter,1);
MEAN=zeros(maxiter,1);
ClusterValue=zeros(maxiter,ClusterNumber);

field1='chromozone';
value1=zeros(1,FileNumber);
field2='chromozonefitness'; 
value2=zeros(1);

pop=struct(field1,value1,field2,value2);
crosspop=struct(field1,value1,field2,value2);
mutpop=struct(field1,value1,field2,value2);

%% create population 
pop=CreatePopulation(npop,FileNumber,ClusterNumber);
pop=CalaulatePopulationFitness(SemanticGraph,pop,ClusterNumber,FileNumber);
%% main loop


for iter=1:maxiter
   % crossover
   crosspop=GenerateCrossover(pop,npop,ClusterNumber,ncross,FileNumber);
   % mutation
   mutpop=GenerateMutation(pop,npop,ClusterNumber,nmut,FileNumber);
   % merged
   [pop1]=[crosspop,mutpop];
   pop1=CalaulatePopulationFitness(SemanticGraph,pop1,ClusterNumber,FileNumber);

  % select
  [pop]=[pop,pop1];
  [value,index]=sort([pop.chromozonefitness] , 'descend');
  pop=pop(index);
  pop=pop(1:npop);
 
 
  if ~isnan(pop(1).chromozonefitness)
   gpop=pop(1);   % Best pop
  else
   break;
  end

 BEST(iter)=gpop.chromozonefitness;
 MEAN(iter)=mean([pop.chromozonefitness]);
 ClusterValue(iter,:)=ShowClusterCount( gpop.chromozone ,ClusterNumber);

 disp([ ' Iter = '  num2str(iter)  ' BEST = '  num2str(BEST(iter))]);
   if iter>ConstIteration && BEST(iter)==BEST(iter-ConstIteration)
      break
 end
end
%% results
save(OutputPreRecall,'gpop'); 

%%
%%create mojo file 
 
 fileID=fopen(OutputMoJo,'w');
 for i=1 :FileNumber
     d= gpop.chromozone(i);
  fprintf(fileID,'contain %d    %s \r\n',d ,FileNames{i});   
 end
fclose(fileID);

%%
disp(' ')
disp([ ' Best par = '  num2str(gpop.chromozone)])
disp([ ' Best fitness = '  num2str(gpop.chromozonefitness)])

FileName=char(strcat(FigureDir,'\BestChromozone.txt'));
v1=gpop.chromozone;
v2=gpop.chromozonefitness;
save(FileName,'v1','v2','ClusterNumber','-ascii'); 

%

% % % h=figure(1);
% % % plot(BEST(1:iter),'r','LineWidth',2)
% % % hold on
% % % plot(MEAN(1:iter),'b','LineWidth',2)
% % % 
% % % xlabel('Iteration')
% % % ylabel(' Fitness')
% % % legend('BEST','MEAN')
% % % title('GA for Semantic Analysis')
% % % 
% % % FileName=char(strcat(FigureDir,'\ClusterBest'));
% % % saveas(h,FileName,'jpg');
% % % set(h, 'Visible', 'off');
% % % 
% % % 
% % % Color1=rand(ClusterNumber,3);
% % % 
% % % for i=1:ClusterNumber
% % % h1=figure('visible','off');
% % % 
% % % 
% % % plot(ClusterValue(1:iter,i),'Color', Color1(i,:),'LineWidth',1)
% % % hold on
% % % xlabel('Iteration')
% % % ylabel(' Cluster number')
% % % 
% % % legend(strcat('Cluster', num2str(i)))
% % % 
% % % 
% % % title('Cluster number in GA for Semantic Analysis')
% % % 
% % % FileName=char(strcat(FigureDir,'\Cluster',num2str(i)));
% % % saveas(h1,FileName,'jpg');
% % % 
% % % [Adj,Ids]=NewShowFileIndexCount(SemanticGraph, FileNames,gpop.chromozone ,i);
% % % f= BioGraphViewer (Adj,Ids);
% % % FileName1=char(strcat(FigureDir,'\ClusterIn',num2str(i),'.jpg'));
% % % print(f, '-djpeg', FileName1);
% % % end
