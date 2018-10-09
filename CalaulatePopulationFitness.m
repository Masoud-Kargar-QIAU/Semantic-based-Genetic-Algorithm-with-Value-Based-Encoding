 
function Population=CalaulatePopulationFitness(SemanticGraph,Population,ClusterNumber,FileNumber)

[~, npop]=size(Population);
mat=zeros(npop,ClusterNumber);

for i=1:npop

    for j=1:ClusterNumber
    ClusterIndex=find(Population(i).chromozone==j);
    [A,B]=size(ClusterIndex);
    mat(i,j,1:B)=ClusterIndex;
    end

end

matTurboMCE=zeros(npop,ClusterNumber);
x=zeros(1,FileNumber);
for i=1:npop

    for j=1:ClusterNumber
    
        x= reshape (mat(i,j,:),1,[]);
        x(x==0)=[];
        InternalNode=length(x);
        SubGraphMatrixIndex=x;
        G1=SemanticGraph(SubGraphMatrixIndex,SubGraphMatrixIndex);
        G1(G1<=0.7)=0;
        InternalLinkSum=sum(G1(:))/2;

   
        G2=SemanticGraph;
        G2(SubGraphMatrixIndex,SubGraphMatrixIndex)=0;
        G3=G2(SubGraphMatrixIndex,:);
        G3(G3<0.9)=0;
        ExtenalLinkSum=sum(G3(:));
        
        m=((InternalLinkSum)/(InternalLinkSum+ExtenalLinkSum));
        matTurboMCE(i,j)=m;
    
    end
    s=sum(matTurboMCE(i,:));
    if ~isnan(s)
    Population(i).chromozonefitness=s;
    else
       Population(i).chromozonefitness=0;
    end
end


         
end
  











