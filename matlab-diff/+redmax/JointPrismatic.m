classdef JointPrismatic < redmax.Joint
	% https://github.com/junggon/gear/blob/master/src/gjoint_prismatic.cpp
	
	%%
	properties
		axis
		sides
	end
	
	%%
	methods
		%%
		function this = JointPrismatic(parent,body,axis)
			this = this@redmax.Joint(parent,body,1);
			this.axis = axis/norm(axis);
			this.sides = [0.5 0.5 0.5];
		end
		
		%%
		function setGeometry(this,sides)
			this.sides = sides;
		end
	end
	
	%%
	methods (Access = protected)
		%%
		function update_(this,deriv)
			a = this.axis;
			p = a*this.q;
			qdot = this.qdot;
			
			this.Q(1:3,4) = p;
			this.A = se3.Ad(this.Q);
			this.S = [zeros(3,1);a];
			abrac = se3.brac(a);
			this.Adot(4:6,1:3) = abrac*qdot;
			
			if deriv
				this.dAdq(4:6,1:3) = abrac;
			end
		end
		
		%%
		function draw_(this)
			E_wj = this.body.E_wi*this.body.E0_ij;
			[F,V] = se3.patchCuboid(E_wj,this.sides);
			patch('Faces',F,'Vertices',V,'FaceColor',this.body.color);
		end
	end
end
