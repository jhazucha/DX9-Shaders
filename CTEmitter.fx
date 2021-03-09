//---------------------------------------------------------------------------
// Emitter Shader Example
//---------------------------------------------------------------------------

float4x4 ModelViewProj : WORLDVIEWPROJECTION;
float Size;
texture tex1;

sampler samp1 = sampler_state
{
	Texture = <tex1>;
	MinFilter = LINEAR;
	MagFilter = LINEAR;
	MipFilter = LINEAR;
};

struct a2v
{ 
  float4 Position		: POSITION0;
  float4 Color			: COLOR0;
  float3 Normal			: NORMAL;
  float2 texCoord		: TEXCOORD0;
};
struct v2p
{
	float4 Position		: POSITION0;
	float4 Color		: COLOR0;
	float2 texCoord		: TEXCOORD0;
	float Size			: PSIZE;
};
struct p2f
{
	float2 texCoord		: TEXCOORD0;
	float4 Color		: COLOR0;
};

void Transform(in a2v IN, out v2p OUT)
{
	// transform our position in model space
	OUT.Position = mul(IN.Position, ModelViewProj);
	
	// just return the color out
	OUT.Color = IN.Color;
	
	// just return the texture
	OUT.texCoord = IN.texCoord;
	
	// scale to our Size
	OUT.Size = Size;
}

float4 Textured(in p2f IN) : COLOR0
{
	return tex2D(samp1, IN.texCoord) * IN.Color;
}

technique PositionTextured
{
  pass p0
  {
    VertexShader = compile vs_1_1 Transform();
    PixelShader = compile ps_2_0 Textured();
  }
}