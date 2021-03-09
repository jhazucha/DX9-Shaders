//Catalyst3D : Sample Textured Mesh Shader - Ambient Lighting
float4x4 ModelViewProj	: WORLDVIEWPROJ;	// WORLD*VIEW*PROJ
float4x4 ModelViewIT	: WORLDVIEWIT;		// Inverse transpose matrix
float4x4 ModelWorld		: WORLD;			// World matrix
float4x4 ModelProjection : PROJECTION;

texture myTexture;
 
sampler samp1 : TEXUNIT0 =  sampler_state
{
  Texture = (myTexture);
  MipFilter = LINEAR;
  MagFilter = LINEAR;
  MinFilter = LINEAR;
  AddressU = CLAMP;
  AddressV = CLAMP;
};

sampler samp1 : TEXUNIT0 = sampler_state
{
  Texture	= (myTexture);
  MipFilter = LINEAR;
  MagFilter = LINEAR;
  MinFilter = LINEAR;
  AddressU = CLAMP;
  AddressV = CLAMP;
  AddressW = CLAMP;
  
};

// application to vertex struct
struct a2v
{ 
    float4 position	: POSITION0;
    float3 normal	: NORMAL;
    float2 texCoord	: TEXCOORD0;
};
 
// vertex to pixel shader struct
struct v2p
{
    float4 position : POSITION0;
    float2 texCoord : TEXCOORD0;
};
 
// pixel shader to screen
struct p2f
{
    float2 texCoord : TEXCOORD0;
};
 
// Vertex Shader
void vs( in a2v IN, out v2p OUT ) 
{
    //getting to position to object space
    OUT.position    = mul(IN.position, ModelViewProj);
 
 		// send our textures out
    OUT.texCoord = IN.texCoord;
}
 
// Pixel Shader
float4 Textured(in p2f IN) : COLOR0
{
  return tex2D(samp1, IN.texCoord);
}

technique Render
{
	pass p0
  	{
		VertexShader = compile vs_1_1 vs();
    	PixelShader = compile ps_2_0 Textured();
  	}
}