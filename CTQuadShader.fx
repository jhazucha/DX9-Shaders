float4x4 WorldViewProj : WORLDVIEWPROJECTION;
float4x4 WorldMatrix : WORLD;

//application to vertex struct
struct a2v
{ 
  float4 Position   : POSITION0;
  float2 TexCoord		: TEXCOORD0;
};


//vertex to pixel shader struct
struct v2p
{
	float4 Position	  : POSITION0;
	float2 TexCoord		: TEXCOORD0;
};

void vShader(in a2v IN, out v2p OUT)
{
	// transform the position into world space
	OUT.Position = mul(IN.Position, WorldViewProj);
	
	// pass texture coords thru
	OUT.TexCoord = IN.TexCoord;
}

technique RenderQuad
{
	pass p0
  {
		VertexShader = compile vs_1_1 vShader();
		PixelShader = null;
  }
}