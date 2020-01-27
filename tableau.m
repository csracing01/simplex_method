pkg load optim

fid = fopen('input.txt', 'r');
basic = fscanf(fid, '%f', 1);
non_basic = fscanf(fid, '%f', 1);

basic_indices = [];
for i = 1:basic
   basic_indices(i) = fscanf(fid, '%f', 1);
end

nonbasic_indices = [];
for i = 1:non_basic
   nonbasic_indices(i) = fscanf(fid, '%f', 1);
end

bi = [];
for i = 1:basic
   bi(i) = fscanf(fid, '%f', 1);
end

A = [[]];
for i = 1:basic
   for j =1:non_basic
       A(i,j) = fscanf(fid, '%f', 1);
   end
end

z0 = fscanf(fid, '%f', 1);

z = [];
for i = 1:non_basic
   z(i) = fscanf(fid, '%f', 1);
end

max = 0;
pos = 0;
for i = 1:non_basic
    if z(i) > 0 && z(i) > max
        max = z(i);
        pos = i;
    end
end

c = 1;
fprintf('\n\n\t\tSIMPLEX METHOD\n\n');
fprintf('\nIteration %d\n', c);


if pos != 0
  entering_var = nonbasic_indices(pos);
  fprintf('\nEntering Variable: x%d\n', entering_var);
else
  fprintf('\nReached Optimal solution!!!\nNo more variable can enter the basis!!!');
  exit;
end

leaving = 0;
loc = 0;
f = 0;
for j =1:basic
   if A(j, pos) < 0
      l = bi(j) / abs(A(j, pos));
      if f == 0
          leaving = l;
          loc = j;
          f = 1;
      elseif f != 0 && l < leaving
          leaving = l;
          loc = j;
      end
   end
end

if loc != 0
   leaving_var = basic_indices(loc);
   fprintf('\nLeaving Variable: x%d\n', leaving_var);
else
   fprintf('\nNo constraint binds the value of x%d', entering_var);
   fprintf('\nSo, No leaving variable!!!\nSo, Unbounded Solution.');
   exit;
end

initial_nonbasic_indices = nonbasic_indices;

while true
    c+=1;
    fprintf('\nIteration %d\n', c);

    basic_indices(loc) = entering_var;
    nonbasic_indices(pos) = leaving_var;
    
    t = -1*A(loc, pos);
    bi(loc) = bi(loc) / t;
    
    for i=1:basic
      if i != loc
         bi(i) = bi(i) + A(i, pos) * bi(loc);
      end
    end
    
    
    A(loc, pos) = -1;
    
    for i=1:non_basic
       A(loc, i) /= t;
    end
    
    for i=1:basic
        for j=1:non_basic
            if i!=loc && j!=pos
                A(i, j) = A(i, j) + A(i, pos) * A(loc, j); 
            end
        end
    end
    
    for i=1:basic
        if i!=loc
           A(i, pos) = A(i, pos) * A(loc, pos);
        end
    end
    
    z0 += z(pos) * bi(loc);
    
    for i=1:non_basic
        if i!=pos
           z(i) = z(i) + z(pos) * A(loc, i);
        end
    end
    
    z(pos) = z(pos) * A(loc, pos);
    
    max = 0;
    pos = 0;
    for i = 1:non_basic
        if z(i) > 0 && z(i) > max
            max = z(i);
            pos = i;
        end
    end
    
    if pos != 0
      entering_var = nonbasic_indices(pos);
      fprintf('\nEntering Variable: x%d\n', entering_var);
    else
      f = 0;
      fprintf('\nReached Optimal solution!!!\nNo more variable can enter the basis!!!');
        
      fprintf('\n\nOptimal value of z: %.2f', z0);
          
      for i=1:non_basic
          f = 0;
          for j=1:basic
              if(initial_nonbasic_indices(i) == basic_indices(j))
                  f = 1;    
                  fprintf('\nx%d: %.2f', basic_indices(j), bi(j));
              end
          end
          if f == 0
              fprintf('\nx%d: %d', initial_nonbasic_indices(i), 0);
          end
      end
      exit;
    end
    
    leaving = 0;
    loc = 0;
    f = 0;
    for j =1:basic
       if A(j, pos) < 0
          l = bi(j) / abs(A(j, pos));
          if f == 0
              leaving = l;
              loc = j;
              f = 1;
          elseif f != 0 && l < leaving
              leaving = l;
              loc = j;
          end
       end
    end
    
    
    if loc != 0
       leaving_var = basic_indices(loc);
       fprintf('\nLeaving Variable: x%d\n', leaving_var);
    else
       fprintf('\nNo constraint binds the value of x%d', entering_var);
       fprintf('\nSo, No leaving variable!!!\nSo, Unbounded Solution.');
       exit;
    end

end

fclose(fid);
